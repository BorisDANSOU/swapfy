import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/users.dart';
import '../models/user.dart';
import '../repositories/users_repository.dart';
import '../l10n/app_localizations.dart';
import '../widgets/match_card.dart';

//Écran Matches : liste tous les utilisateurs compatibles, triés du
//plus compatible au moins compatible.
//StatelessWidget : affiche simplement les données déjà triées.
class MatchesScreen extends StatelessWidget {
  final UsersRepository? usersRepository;

  const MatchesScreen({super.key, this.usersRepository});

  @override
  Widget build(BuildContext context) {
    final repository = usersRepository;
    if (repository != null) {
      return StreamBuilder(
        stream: repository.watchMatches(),
        builder: (context, snapshot) {
          final l10n = AppLocalizations.of(context)!;
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text(l10n.loadMatchesFailed)));
          }
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return _buildContent(context, snapshot.data!);
        },
      );
    }
    return _buildContent(context, MockUsers.matchesSortedByCompatibility);
  }

  Widget _buildContent(BuildContext context, List<User> matches) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.matchesTitle)),
      body: matches.isEmpty
          ? Center(child: Text(l10n.noMatches))
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
