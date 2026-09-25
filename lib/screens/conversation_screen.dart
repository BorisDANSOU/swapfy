import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../data/users.dart';
import '../repositories/fake/fake_messages_repository.dart';
import '../repositories/messages_repository.dart';
import '../widgets/remote_avatar.dart';

//Écran de conversation avec un utilisateur précis. Reçoit un "userId"
//en paramètre (transmis par app/router.dart), et retrouve l'utilisateur
//correspondant pour afficher son nom/avatar dans l'AppBar.
//StatefulWidget car on gère la saisie et l'envoi de messages localement.
class ConversationScreen extends StatefulWidget {
  final String userId;
  final MessagesRepository? messagesRepository;

  const ConversationScreen({
    super.key,
    required this.userId,
    this.messagesRepository,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

//Petit modèle local (pas dans models/) pour représenter un message
//dans cette conversation simulée.
class _ChatMessage {
  final String text;
  final bool isMe;
  const _ChatMessage({required this.text, required this.isMe});
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  late final MessagesRepository _messagesRepository =
      widget.messagesRepository ?? FakeMessagesRepository();

  //Messages simulés, pré-remplis pour un rendu réaliste dès l'ouverture,
  //comme vu sur ta maquette (Sarah K. → Boris).
  final List<_ChatMessage> _messages = [
    const _ChatMessage(text: 'Salut Boris ! Comment vas-tu ?', isMe: false),
    const _ChatMessage(
      text: 'Salut Sarah ! Ça va très bien et toi ?',
      isMe: true,
    ),
    const _ChatMessage(
      text: 'Oui super ! On peut commencer l\'échange demain à 15h ?',
      isMe: false,
    ),
    const _ChatMessage(
      text: 'Parfait ! On se retrouve sur Google Meet alors.',
      isMe: true,
    ),
    const _ChatMessage(text: 'Nickel, à demain !', isMe: false),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    if (_messagesRepository case final FakeMessagesRepository repository) {
      repository.dispose();
    }
    super.dispose();
  }

  //Ajoute le message tapé à la liste, s'il n'est pas vide.
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isMe: true));
      _messageController.clear();
    });
    await _messagesRepository.sendMessage(widget.userId, text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //widget.userId : le State accède aux paramètres du widget parent
    //via "widget.", règle systématique en StatefulWidget.
    final user = MockUsers.getById(widget.userId);

    return Scaffold(
      appBar: AppBar(
        title: user != null
            ? Row(
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
              )
            : const Text('Conversation'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                //Message "de moi" aligné à droite avec dégradé violet-bleu ;
                //message "de l'autre" aligné à gauche, couleur neutre.
                return Align(
                  alignment: message.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      gradient: message.isMe ? AppTheme.primaryGradient : null,
                      color: message.isMe
                          ? null
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isMe
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
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
                    decoration: const InputDecoration(
                      hintText: 'Écrire un message...',
                    ),
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
