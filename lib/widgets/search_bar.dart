import 'package:flutter/material.dart';

//Barre de recherche réutilisable, utilisée dans Explore et Messages.
//Le parent garde le contrôle du texte via un TextEditingController.
class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final Widget? trailing; // ex: bouton de filtre à droite (Explore)

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search, size: 20),
            ),
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}
