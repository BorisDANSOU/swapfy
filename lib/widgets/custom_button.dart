import 'package:flutter/material.dart';
import '../app/theme.dart';

//Bouton réutilisable avec 2 variantes :
//- primary : fond en dégradé violet-bleu (ex: "Échanger")
//- outline : contour seulement (ex: "Voir")
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isSmall; // version compacte pour les cartes (ex: bouton "Voir")

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final verticalPadding = isSmall ? 8.0 : 14.0;
    final fontSize = isSmall ? 13.0 : 15.0;

    final content = Semantics(
      button: true,
      label: label,
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize),
      ),
    );

    if (isOutlined) {
      return Semantics(
        button: true,
        label: label,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primaryPurple,
            side: const BorderSide(color: AppTheme.primaryPurple, width: 1.5),
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: content,
        ),
      );
    }

    //Un ElevatedButton classique ne supporte pas de dégradé en fond,
    //donc on enveloppe un bouton transparent dans un Container qui,
    //lui, porte le dégradé en arrière-plan.
    return Semantics(
      button: true,
      label: label,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(100),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: content,
        ),
      ),
    );
  }
}
