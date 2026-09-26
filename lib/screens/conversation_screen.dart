import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../data/users.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../l10n/app_localizations.dart';
import '../repositories/fake/fake_messages_repository.dart';
import '../repositories/messages_repository.dart';
import '../repositories/users_repository.dart';
import '../widgets/remote_avatar.dart';

//Écran de conversation avec un utilisateur précis. Reçoit un "userId"
//en paramètre (transmis par app/router.dart), et retrouve l'utilisateur
//correspondant pour afficher son nom/avatar dans l'AppBar.
//StatefulWidget car il gère la saisie et l'envoi de messages.
class ConversationScreen extends StatefulWidget {
  final String userId;
  final MessagesRepository? messagesRepository;
  final UsersRepository? usersRepository;

  const ConversationScreen({
    super.key,
    required this.userId,
    this.messagesRepository,
    this.usersRepository,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  late final MessagesRepository _messagesRepository =
      widget.messagesRepository ?? FakeMessagesRepository();
  late final bool _ownsMessagesRepository = widget.messagesRepository == null;
  late final Future<String> _conversationId;
  late final Future<User?> _partner;

  @override
  void initState() {
    super.initState();
    _conversationId = _messagesRepository.openOrCreateConversation(
      widget.userId,
    );
    _partner =
        widget.usersRepository?.getById(widget.userId) ??
        Future.value(MockUsers.getById(widget.userId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    if (_ownsMessagesRepository) {
      if (_messagesRepository case final FakeMessagesRepository repository) {
        repository.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    final conversationId = await _conversationId;
    await _messagesRepository.sendMessage(conversationId, text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<User?>(
          future: _partner,
          builder: (context, snapshot) {
            final user = snapshot.data;
            if (user == null) return Text(l10n.conversationTitle);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RemoteAvatar(
                  imageUrl: user.avatarUrl,
                  name: user.name,
                  radius: 16,
                ),
                const SizedBox(width: 10),
                Text(user.name),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<String>(
              future: _conversationId,
              builder: (context, conversationSnapshot) {
                if (conversationSnapshot.hasError) {
                  return Center(child: Text(l10n.loadConversationFailed));
                }
                if (!conversationSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return StreamBuilder<List<Message>>(
                  stream: _messagesRepository.watchMessages(
                    conversationSnapshot.data!,
                  ),
                  builder: (context, messagesSnapshot) {
                    if (messagesSnapshot.hasError) {
                      return Center(child: Text(l10n.loadMessagesFailed));
                    }
                    if (!messagesSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final messages = messagesSnapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe =
                            message.senderId ==
                            _messagesRepository.currentUserId;
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              gradient: isMe ? AppTheme.primaryGradient : null,
                              color: isMe
                                  ? null
                                  : theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Semantics(
                              label: isMe
                                  ? l10n.messageFromYou(message.text)
                                  : l10n.messageFromPartner(
                                      widget.userId,
                                      message.text,
                                    ),
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  color: isMe
                                      ? Colors.white
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          //Zone de saisie en bas de l'écran.
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: l10n.writeMessage),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                //Bouton d'envoi rond en dégradé, comme vu sur ta maquette.
                Container(
                  decoration: const BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    tooltip: l10n.sendMessage,
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
