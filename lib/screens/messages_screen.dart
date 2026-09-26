import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/users.dart';
import '../models/conversation.dart';
import '../models/user.dart';
import '../l10n/app_localizations.dart';
import '../repositories/messages_repository.dart';
import '../repositories/users_repository.dart';
import '../widgets/remote_avatar.dart';

//Écran Messages : liste des conversations, avec dernier message et
//horodatage simulés (pas de vraie messagerie persistante, hors scope).
//StatefulWidget car on gère une recherche locale (comme Explore).
class MessagesScreen extends StatefulWidget {
  final MessagesRepository? messagesRepository;
  final UsersRepository? usersRepository;

  const MessagesScreen({
    super.key,
    this.messagesRepository,
    this.usersRepository,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //Filtre les contacts (tous les utilisateurs sauf l'utilisateur
  //connecté) par nom, selon le texte tapé.
  List<User> _filteredUsers(List<User> users) {
    final query = _searchController.text.toLowerCase();
    final contacts = users
        .where((user) => user.id != MockUsers.currentUserId)
        .toList();
    if (query.isEmpty) return contacts;
    return contacts.where((u) => u.name.toLowerCase().contains(query)).toList();
  }

  //Génère un faux dernier message et horodatage à partir de l'index,
  //pour un rendu réaliste sans vrai système de messagerie.
  String _fakeLastMessage(int index) {
    const messages = [
      'Salut Boris ! On peut commencer ?',
      'Parfait, je suis dispo !',
      'Merci pour l\'échange 🙏',
      'On continue demain ?',
      'Super, merci !',
    ];
    return messages[index % messages.length];
  }

  String _fakeTimestamp(int index) {
    const timestamps = ['10:30', 'Hier', '2j', 'Lun.', '3j'];
    return timestamps[index % timestamps.length];
  }

  String _formatTimestamp(DateTime? date, int index) {
    if (date == null) return _fakeTimestamp(index);
    final localDate = date.toLocal();
    return '${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final messagesRepository = widget.messagesRepository;
    final usersRepository = widget.usersRepository;
    if (messagesRepository != null && usersRepository != null) {
      return StreamBuilder<List<Conversation>>(
        stream: messagesRepository.watchConversations(),
        builder: (context, conversationsSnapshot) {
          final l10n = AppLocalizations.of(context)!;
          if (conversationsSnapshot.hasError) {
            return Scaffold(
              body: Center(child: Text(l10n.loadConversationsFailed)),
            );
          }
          if (!conversationsSnapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return StreamBuilder<List<User>>(
            stream: usersRepository.watchMatches(),
            builder: (context, usersSnapshot) {
              final l10n = AppLocalizations.of(context)!;
              if (usersSnapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text(l10n.loadProfilesFailed)),
                );
              }
              if (!usersSnapshot.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return _buildContent(
                context,
                users: usersSnapshot.data!,
                conversations: conversationsSnapshot.data,
                currentUserId: messagesRepository.currentUserId,
              );
            },
          );
        },
      );
    }
    return _buildContent(context, users: MockUsers.users);
  }

  Widget _buildContent(
    BuildContext context, {
    required List<User> users,
    List<Conversation>? conversations,
    String? currentUserId,
  }) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final entries =
        <({Conversation? conversation, String userId, User? user})>[];
    if (conversations == null) {
      entries.addAll(
        _filteredUsers(
          users,
        ).map((user) => (conversation: null, userId: user.id, user: user)),
      );
    } else {
      final query = _searchController.text.toLowerCase();
      for (final conversation in conversations) {
        final partnerIds = conversation.participantIds.where(
          (id) => id != currentUserId,
        );
        if (partnerIds.isEmpty) continue;
        final partnerId = partnerIds.first;
        User? user;
        for (final candidate in users) {
          if (candidate.id == partnerId) {
            user = candidate;
            break;
          }
        }
        if (user != null && user.name.toLowerCase().contains(query)) {
          entries.add((
            conversation: conversation,
            userId: partnerId,
            user: user,
          ));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.messagesTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchConversation,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Expanded(
            child: entries.isEmpty
                ? Center(child: Text(l10n.noConversations))
                : ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      final user = entry.user;
                      if (user == null) return const SizedBox.shrink();
                      return ListTile(
                        leading: Stack(
                          children: [
                            RemoteAvatar(
                              imageUrl: user.avatarUrl,
                              name: user.name,
                            ),
                            //Point vert "en ligne" superposé en bas à
                            //droite de l'avatar, si applicable.
                            if (user.isOnline)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.scaffoldBackgroundColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(user.name),
                        subtitle: Text(
                          entry.conversation == null
                              ? _fakeLastMessage(index)
                              : entry.conversation!.lastMessage ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          _formatTimestamp(
                            entry.conversation?.updatedAt,
                            index,
                          ),
                          style: theme.textTheme.labelSmall,
                        ),
                        onTap: () => context.goNamed(
                          'conversation',
                          pathParameters: {'userId': entry.userId},
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 3,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.goNamed('home');
              break;
            case 1:
              context.goNamed('explore');
              break;
            case 2:
              context.goNamed('matches');
              break;
            case 4:
              context.goNamed('profile');
              break;
          }
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: l10n.navExplore,
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: l10n.navMatches,
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: l10n.navMessages,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
