import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/skills.dart';
import '../data/users.dart';
import '../models/skill.dart';
import '../models/user.dart';
import '../repositories/skills_repository.dart';
import '../repositories/users_repository.dart';
import '../l10n/app_localizations.dart';
import '../widgets/skill_chip.dart';
import '../widgets/user_card.dart';
import '../widgets/custom_button.dart';

//Écran de détail d'une compétence. Reçoit un "skillId" en paramètre
//(transmis par app/router.dart), et retrouve lui-même la compétence
//complète correspondante dans les données mockées.
//StatelessWidget : n'affiche que des données reçues/retrouvées.
class SkillDetailScreen extends StatelessWidget {
  final String skillId;
  final SkillsRepository? skillsRepository;
  final UsersRepository? usersRepository;

  const SkillDetailScreen({
    super.key,
    required this.skillId,
    this.skillsRepository,
    this.usersRepository,
  });

  //Convertit le niveau (enum) en une valeur 0.0-1.0 pour la barre
  //de progression "Niveau moyen" vue sur ta maquette.
  double _levelProgress(SkillLevel level) {
    switch (level) {
      case SkillLevel.beginner:
        return 0.33;
      case SkillLevel.intermediate:
        return 0.66;
      case SkillLevel.expert:
        return 1.0;
    }
  }

  String _localizedLevel(AppLocalizations l10n, SkillLevel level) {
    return switch (level) {
      SkillLevel.beginner => l10n.beginner,
      SkillLevel.intermediate => l10n.intermediate,
      SkillLevel.expert => l10n.expert,
    };
  }

  @override
  Widget build(BuildContext context) {
    final skills = skillsRepository;
    if (skills == null) {
      final skill = MockSkills.getById(skillId);
      return _buildForSkill(context, skill);
    }
    return FutureBuilder<Skill?>(
      future: skills.getById(skillId),
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
        return _buildForSkill(context, snapshot.data);
      },
    );
  }

  Widget _buildForSkill(BuildContext context, Skill? skill) {
    final l10n = AppLocalizations.of(context)!;
    if (skill == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.skillNotFound)),
      );
    }

    final repository = usersRepository;
    if (repository == null) {
      return _buildContent(
        context,
        skill,
        MockUsers.getById(skill.authorId),
        MockUsers.users,
      );
    }
    return FutureBuilder<({User? author, List<User> users})>(
      future: _loadUsers(repository, skill),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text(l10n.loadProfilesFailed)));
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _buildContent(
          context,
          skill,
          snapshot.data!.author,
          snapshot.data!.users,
        );
      },
    );
  }

  Future<({User? author, List<User> users})> _loadUsers(
    UsersRepository repository,
    Skill skill,
  ) async {
    final author = await repository.getById(skill.authorId);
    final users = await repository.watchMatches().first;
    return (author: author, users: users);
  }

  Widget _buildContent(
    BuildContext context,
    Skill skill,
    User? author,
    List<User> users,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    //Utilisateurs qui maîtrisent aussi cette compétence, en excluant
    //l'auteur (déjà mis en avant séparément).
    final peopleWhoKnow = users
        .where(
          (user) =>
              user.skillsOffered.contains(skill.title) &&
              user.id != skill.authorId,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          //Bannière illustrative (icône colorée, pas de vraie image
          //pour rester simple et éviter les soucis de chargement réseau).
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.bolt, size: 44, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),

          SkillChip(
            label: skill.category,
            backgroundColor: theme.colorScheme.secondary.withValues(
              alpha: 0.15,
            ),
            textColor: theme.colorScheme.secondary,
          ),
          const SizedBox(height: 10),
          Text(skill.title, style: theme.textTheme.headlineLarge),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.people_outline,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.peopleCount(skill.studentsCount),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 20),

          //--- Barre "Niveau moyen" ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.averageLevel, style: theme.textTheme.titleMedium),
              Text(
                _localizedLevel(l10n, skill.level),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: _levelProgress(skill.level),
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 20),

          Text(l10n.description, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(skill.description, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),

          //--- Compétences associées ---
          if (skill.associatedSkills.isNotEmpty) ...[
            Text(l10n.relatedSkills, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skill.associatedSkills
                  .map((s) => SkillChip(label: s))
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],

          //--- Personnes qui maîtrisent cette compétence ---
          if (peopleWhoKnow.isNotEmpty) ...[
            Text(
              l10n.peopleKnowSkill(skill.title),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...peopleWhoKnow.map(
              (user) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: UserCard(
                  user: user,
                  subtitle: user.compatibilityPercent >= 80
                      ? l10n.expertLevel
                      : l10n.intermediateLevel,
                  badgeText: '${user.compatibilityPercent}%',
                  onTap: () => context.goNamed(
                    'conversation',
                    pathParameters: {'userId': user.id},
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          //--- Bouton d'action principal ---
          if (author != null)
            CustomButton(
              label: l10n.exchangeProposal,
              onPressed: () => context.goNamed(
                'conversation',
                pathParameters: {'userId': author.id},
              ),
            ),
        ],
      ),
    );
  }
}
