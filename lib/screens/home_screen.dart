import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/skills.dart';
import '../data/users.dart';
import '../models/skill.dart';
import '../models/user.dart';
import '../l10n/app_localizations.dart';
import '../repositories/skills_repository.dart';
import '../repositories/users_repository.dart';
import '../widgets/skill_chip.dart';
import '../widgets/match_card.dart';

//Écran d'accueil : salutation, compétences de l'utilisateur, suggestions
//de matches ("Pour toi"), et compétences populaires.
//StatelessWidget : n'affiche que des données mockées, sans état interne.
class HomeScreen extends StatelessWidget {
  final SkillsRepository? skillsRepository;
  final UsersRepository? usersRepository;

  const HomeScreen({super.key, this.skillsRepository, this.usersRepository});

  @override
  Widget build(BuildContext context) {
    final users = usersRepository;
    final skills = skillsRepository;
    if (users == null || skills == null) {
      return _buildContent(
        context,
        MockUsers.currentUser,
        MockUsers.matchesSortedByCompatibility,
        MockSkills.skills,
      );
    }

    return StreamBuilder<User?>(
      stream: users.watchCurrentUser(),
      builder: (context, userSnapshot) {
        final l10n = AppLocalizations.of(context)!;
        if (userSnapshot.hasError) {
          return Scaffold(body: Center(child: Text(l10n.loadProfileFailed)));
        }
        if (!userSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = userSnapshot.data;
        if (user == null) {
          return Scaffold(body: Center(child: Text(l10n.profileMissing)));
        }
        return StreamBuilder<List<User>>(
          stream: users.watchMatches(),
          builder: (context, matchesSnapshot) {
            final l10n = AppLocalizations.of(context)!;
            if (matchesSnapshot.hasError) {
              return Scaffold(
                body: Center(child: Text(l10n.loadMatchesFailed)),
              );
            }
            if (!matchesSnapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return StreamBuilder<List<Skill>>(
              stream: skills.watchSkills(),
              builder: (context, skillsSnapshot) {
                final l10n = AppLocalizations.of(context)!;
                if (skillsSnapshot.hasError) {
                  return Scaffold(
                    body: Center(child: Text(l10n.loadSkillsFailed)),
                  );
                }
                if (!skillsSnapshot.hasData) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return _buildContent(
                  context,
                  user,
                  matchesSnapshot.data!,
                  skillsSnapshot.data!,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    User currentUser,
    List<User> matches,
    List<Skill> skills,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    //Les 2 meilleurs matches pour la section "Pour toi".
    final topMatches = matches.take(2).toList();
    //Les compétences les plus populaires, triées par nombre d'étudiants.
    final popularSkills = List.of(skills)
      ..sort((a, b) => b.studentsCount.compareTo(a.studentsCount));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeGreeting(currentUser.name.split(' ').first)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.homePrompt, style: theme.textTheme.headlineLarge),
          const SizedBox(height: 16),

          //Barre de recherche cliquable : redirige vers Explore
          //(la vraie recherche interactive se fait sur cet écran dédié).
          Semantics(
            button: true,
            label: l10n.searchSkill,
            child: InkWell(
              onTap: () => context.goNamed('explore'),
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.searchSkill,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: const Icon(Icons.tune),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          //--- Section "Tes compétences" ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.yourSkills, style: theme.textTheme.titleMedium),
              TextButton(
                onPressed: () => context.goNamed('explore'),
                child: Text(l10n.viewAll),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            //On génère un SkillChip par compétence RÉELLE de l'utilisateur
            //connecté, pas de données écrites en dur.
            children: currentUser.skillsOffered
                .map((skill) => SkillChip(label: skill))
                .toList(),
          ),
          const SizedBox(height: 24),

          //--- Section "Pour toi" (suggestions de matches) ---
          Text(l10n.forYou, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          ...topMatches.map(
            (user) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MatchCard(
                user: user,
                onExchange: () => context.goNamed(
                  'conversation',
                  pathParameters: {'userId': user.id},
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          //--- Section "Compétences populaires" ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.popularSkills, style: theme.textTheme.titleMedium),
              TextButton(
                onPressed: () => context.goNamed('explore'),
                child: Text(l10n.viewAll),
              ),
            ],
          ),
          const SizedBox(height: 8),
          //Carrousel horizontal d'icônes de compétences.
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: popularSkills.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final skill = popularSkills[index];
                return Semantics(
                  button: true,
                  label: skill.title,
                  child: InkWell(
                    onTap: () => context.goNamed(
                      'skillDetail',
                      pathParameters: {'id': skill.id},
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: Icon(
                            Icons.bolt,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(skill.title, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          switch (index) {
            case 1:
              context.goNamed('explore');
              break;
            case 2:
              context.goNamed('matches');
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
