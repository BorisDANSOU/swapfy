import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/skills.dart';
import '../models/skill.dart';
import '../widgets/skill_chip.dart';

//Écran Explore : liste toutes les compétences, groupées par catégorie,
//avec recherche par texte et filtrage par catégorie.
//StatefulWidget car il faut RETENIR le texte tapé et la catégorie
//sélectionnée, pour rafraîchir l'affichage à chaque changement.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  //null = "toutes les catégories" (aucun filtre actif).
  String? _selectedCategory;

  @override
  void dispose() {
    //Toujours libérer un TextEditingController pour éviter les fuites
    //mémoire quand l'écran est fermé.
    _searchController.dispose();
    super.dispose();
  }

  //Recalcule la liste filtrée à chaque accès, en combinant recherche
  //texte ET filtre de catégorie.
  List<Skill> get _filteredSkills {
    final query = _searchController.text.toLowerCase();
    return MockSkills.skills.where((skill) {
      final matchesQuery = skill.title.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == null || skill.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = MockSkills.categories;

    //Regroupe les compétences filtrées par catégorie, pour un affichage
    //en sections (comme "Développement", "Design" sur ta maquette).
    final grouped = <String, List<Skill>>{};
    for (final skill in _filteredSkills) {
      grouped.putIfAbsent(skill.category, () => []).add(skill);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Explorer les compétences')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Rechercher une compétence...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  //Chaque frappe déclenche un setState, qui force Flutter
                  //à relire _filteredSkills avec le nouveau texte.
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 12),
                //Ligne de chips filtres, Wrap pour gérer le retour
                //à la ligne si trop de catégories.
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SkillChip(
                      label: 'Toutes',
                      isSelected: _selectedCategory == null,
                      onTap: () => setState(() => _selectedCategory = null),
                    ),
                    //Un chip par catégorie EXISTANTE dans les données,
                    //généré dynamiquement (pas écrit en dur).
                    ...categories.map(
                      (category) => SkillChip(
                        label: category,
                        isSelected: _selectedCategory == category,
                        onTap: () =>
                            setState(() => _selectedCategory = category),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: grouped.isEmpty
                ? Center(
                    child: Text(
                      'Aucune compétence trouvée.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: grouped.entries.map((entry) {
                      final category = entry.key;
                      final skillsInCategory = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Text(category, style: theme.textTheme.titleMedium),
                          const SizedBox(height: 8),
                          ...skillsInCategory.map(
                            (skill) => Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: theme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  child: Icon(
                                    Icons.bolt,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                title: Text(skill.title),
                                subtitle: Text(
                                  '${skill.studentsCount} personnes',
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => context.goNamed(
                                  'skillDetail',
                                  pathParameters: {'id': skill.id},
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.goNamed('home');
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
