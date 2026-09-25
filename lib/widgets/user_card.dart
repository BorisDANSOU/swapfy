import 'package:flutter/material.dart';
import '../models/user.dart';
import 'custom_button.dart';
import 'remote_avatar.dart';

//Carte réutilisable affichant un utilisateur : utilisée dans SkillDetail
//("Personnes qui maîtrisent X") et Messages (liste de contacts).
class UserCard extends StatelessWidget {
  final User user;
  final String? subtitle;
  final String? badgeText; // ex: "95% Match"
  final VoidCallback? onTap;

  const UserCard({
    super.key,
    required this.user,
    this.subtitle,
    this.badgeText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RemoteAvatar(
                  imageUrl: user.avatarUrl,
                  name: user.name,
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: theme.textTheme.titleMedium),
                      if (subtitle != null)
                        Text(subtitle!, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                //Badge de match (ex: pourcentage), affiché seulement
                //si fourni par le parent.
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: theme.brightness == Brightness.light
                          ? const LinearGradient(
                              colors: [Color(0xFF6C5CE7), Color(0xFF00B4D8)],
                            )
                          : null,
                      color: theme.brightness == Brightness.dark
                          ? theme.colorScheme.primary
                          : null,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      badgeText!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                label: 'Voir',
                isOutlined: true,
                isSmall: true,
                onPressed: onTap ?? () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
