import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/skills.dart';
import '../data/users.dart';
import '../widgets/skill_chip.dart';
import '../widgets/match_card.dart';

//Écran d'accueil : salutation, compétences de l'utilisateur, suggestions
//de matches ("Pour toi"), et compétences populaires.
//StatelessWidget : n'affiche que des données mockées, sans état interne.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = MockUsers.currentUser;

    //Les 2 meilleurs matches pour la section "Pour toi".
    final topMatches = MockUsers.matchesSortedByCompatibility.take(2).toList();
    //Les compétences les plus populaires, triées par nombre d'étudiants.
    final popularSkills = List.of(MockSkills.skills)
      ..sort((a, b) => b.studentsCount.compareTo(a.studentsCount));

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello ${currentUser.name.split(' ').first}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Qu\'aimerais-tu apprendre aujourd\'hui ?',
            style: theme.textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),

          //Barre de recherche cliquable : redirige vers Explore
          //(la vraie recherche interactive se fait sur cet écran dédié).
          GestureDetector(
            onTap: () => context.goNamed('explore'),
            child: AbsorbPointer(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher une compétence...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.tune),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          //--- Section "Tes compétences" ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tes compétences', style: theme.textTheme.titleMedium),
              TextButton(onPressed: () {}, child: const Text('Voir tout')),
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
          Text('Pour toi ✨', style: theme.textTheme.titleMedium),
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
              Text(
                'Compétences populaires 🔥',
                style: theme.textTheme.titleMedium,
              ),
              TextButton(onPressed: () {}, child: const Text('Voir tout')),
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
                return GestureDetector(
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
