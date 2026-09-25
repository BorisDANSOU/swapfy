import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/users.dart';
import '../widgets/match_card.dart';

//Écran Matches : liste tous les utilisateurs compatibles, triés du
//plus compatible au moins compatible.
//StatelessWidget : affiche simplement les données déjà triées.
class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //matchesSortedByCompatibility fait tout le travail de tri et
    //d'exclusion de l'utilisateur connecté (voir data/users.dart).
    final matches = MockUsers.matchesSortedByCompatibility;

    return Scaffold(
      appBar: AppBar(title: const Text('Tes meilleurs matchs')),
      body: matches.isEmpty
          ? const Center(child: Text('Aucun match pour le moment.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: matches.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = matches[index];
                return MatchCard(
                  user: user,
                  //Au clic sur "Échanger", on ouvre la conversation
                  //avec cette personne (même mécanisme de paramètre
                  //dynamique que pour SkillDetail).
                  onExchange: () => context.goNamed(
                    'conversation',
                    pathParameters: {'userId': user.id},
                  ),
                );
              },
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.goNamed('home');
              break;
            case 1:
              context.goNamed('explore');
              break;
            case 3:
              context.goNamed('messages');
              break;
            case 4:
              context.goNamed('profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Matches',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
