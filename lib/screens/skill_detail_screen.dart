import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/skills.dart';
import '../data/users.dart';
import '../models/skill.dart';
import '../widgets/skill_chip.dart';
import '../widgets/user_card.dart';
import '../widgets/custom_button.dart';

//Écran de détail d'une compétence. Reçoit un "skillId" en paramètre
//(transmis par app/router.dart), et retrouve lui-même la compétence
//complète correspondante dans les données mockées.
//StatelessWidget : n'affiche que des données reçues/retrouvées.
class SkillDetailScreen extends StatelessWidget {
  final String skillId;

  const SkillDetailScreen({super.key, required this.skillId});

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skill = MockSkills.getById(skillId);

    //Cas où l'id ne correspond à aucune compétence (lien invalide).
    //On affiche un message clair plutôt que de planter.
    if (skill == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Cette compétence n\'existe pas.')),
      );
    }

    final author = MockUsers.getById(skill.authorId);
    //Utilisateurs qui maîtrisent aussi cette compétence, en excluant
    //l'auteur (déjà mis en avant séparément).
    final peopleWhoKnow = MockUsers.users
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
                '${skill.studentsCount} personnes maîtrisent cette compétence',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 20),

          //--- Barre "Niveau moyen" ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Niveau moyen', style: theme.textTheme.titleMedium),
              Text(skill.level.label, style: theme.textTheme.bodyMedium),
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

          Text('Description', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(skill.description, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),

          //--- Compétences associées ---
          if (skill.associatedSkills.isNotEmpty) ...[
            Text('Compétences associées', style: theme.textTheme.titleMedium),
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
              'Personnes qui maîtrisent ${skill.title}',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...peopleWhoKnow.map(
              (user) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: UserCard(
                  user: user,
                  subtitle: user.compatibilityPercent >= 80
                      ? 'Expert Level'
                      : 'Intermediate Level',
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
              label: 'Proposer un échange',
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
