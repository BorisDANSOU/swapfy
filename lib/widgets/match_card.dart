import 'package:flutter/material.dart';
import '../models/user.dart';
import 'custom_button.dart';
import 'remote_avatar.dart';

//Carte réutilisable affichant un match avec son pourcentage de
//compatibilité en cercle de progression, ce qu'il enseigne/recherche.
//Utilisée dans Home ("Pour toi") et l'écran Matches.
class MatchCard extends StatelessWidget {
  final User user;
  final VoidCallback? onExchange;

  const MatchCard({super.key, required this.user, this.onExchange});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RemoteAvatar(imageUrl: user.avatarUrl, name: user.name),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: theme.textTheme.titleMedium),
                      Text(
                        //On affiche "compétence enseignée → compétence
                        //recherchée", en gérant le cas de listes vides.
                        '${user.skillsOffered.isNotEmpty ? user.skillsOffered.first : "-"} '
                        '→ ${user.skillsWanted.isNotEmpty ? user.skillsWanted.first : "-"}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                //Cercle de progression représentant le % de compatibilité,
                //comme vu sur ton moodboard (cercle autour du %).
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: user.compatibilityPercent / 100,
                        strokeWidth: 4,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation(
                          theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        '${user.compatibilityPercent}%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                label: 'Échanger',
                onPressed: onExchange ?? () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
