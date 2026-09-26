import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/skills.dart';
import '../models/skill.dart';
import '../repositories/skills_repository.dart';
import '../l10n/app_localizations.dart';
import '../widgets/skill_chip.dart';

//Écran Explore : liste toutes les compétences, groupées par catégorie,
//avec recherche par texte et filtrage par catégorie.
//StatefulWidget car il faut RETENIR le texte tapé et la catégorie
//sélectionnée, pour rafraîchir l'affichage à chaque changement.
class ExploreScreen extends StatefulWidget {
  final SkillsRepository? skillsRepository;

  const ExploreScreen({super.key, this.skillsRepository});

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
  List<Skill> _filteredSkills(List<Skill> skills) {
    final query = _searchController.text.toLowerCase();
    return skills.where((skill) {
      final matchesQuery = skill.title.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == null || skill.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final repository = widget.skillsRepository;
    if (repository != null) {
      return StreamBuilder<List<Skill>>(
        stream: repository.watchSkills(),
        builder: (context, snapshot) {
          final l10n = AppLocalizations.of(context)!;
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text(l10n.loadSkillsFailed)));
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
    return _buildContent(context, MockSkills.skills);
  }

  Widget _buildContent(BuildContext context, List<Skill> skills) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final categories = skills.map((skill) => skill.category).toSet().toList()
      ..sort();

    //Regroupe les compétences filtrées par catégorie, pour un affichage
    //en sections (comme "Développement", "Design" sur ta maquette).
    final grouped = <String, List<Skill>>{};
    for (final skill in _filteredSkills(skills)) {
      grouped.putIfAbsent(skill.category, () => []).add(skill);
    }
    final rows = <({String? category, Skill? skill})>[];
    for (final entry in grouped.entries) {
      rows.add((category: entry.key, skill: null));
      rows.addAll(entry.value.map((skill) => (category: null, skill: skill)));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.exploreTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.searchSkill,
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
                      label: l10n.categoryAll,
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
                      l10n.noSkillsFound,
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      final skill = row.skill;
                      if (skill == null) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 8),
                          child: Text(
                            row.category!,
                            style: theme.textTheme.titleMedium,
                          ),
                        );
                      }
                      return Card(
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
                          subtitle: Text(l10n.peopleCount(skill.studentsCount)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.goNamed(
                            'skillDetail',
                            pathParameters: {'id': skill.id},
                          ),
                        ),
                      );
                    },
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
