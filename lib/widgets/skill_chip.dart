import 'package:flutter/material.dart';

//Petit badge arrondi affichant une compétence, catégorie ou niveau
//(ex: "Flutter", "Développement", "Débutant"). Utilisé dans Home
//(compétences de l'utilisateur), Explore (filtres), SkillDetail
//(compétences associées), Profile (compétences maîtrisées/recherchées).
class SkillChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isSelected; // pour les filtres cliquables (Explore)
  final VoidCallback? onTap;

  const SkillChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //Si aucune couleur n'est fournie, on utilise une couleur par défaut
    //qui change selon l'état "sélectionné" (utile pour les filtres).
    final bg = backgroundColor ??
        (isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.15)
            : theme.colorScheme.surfaceContainerHighest);
    final fg = textColor ??
        (isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: fg),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}