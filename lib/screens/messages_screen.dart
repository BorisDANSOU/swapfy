import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/users.dart';
import '../models/user.dart';

//Écran Messages : liste des conversations, avec dernier message et
//horodatage simulés (pas de vraie messagerie persistante, hors scope).
//StatefulWidget car on gère une recherche locale (comme Explore).
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

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
  List<User> get _filteredUsers {
    final query = _searchController.text.toLowerCase();
    final contacts =
        MockUsers.users.where((u) => u.id != MockUsers.currentUserId).toList();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final users = _filteredUsers;

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Rechercher une conversation...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Expanded(
            child: users.isEmpty
                ? const Center(child: Text('Aucune conversation trouvée.'))
                : ListView.separated(
                    itemCount: users.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(user.avatarUrl),
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
                          _fakeLastMessage(index),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(_fakeTimestamp(index), style: theme.textTheme.labelSmall),
                        onTap: () => context.goNamed(
                          'conversation',
                          pathParameters: {'userId': user.id},
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
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explorer'),
          NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: 'Matches'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}