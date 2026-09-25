import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app/theme_controller.dart';
import '../data/users.dart';
import '../widgets/skill_chip.dart';
import '../widgets/custom_button.dart';
import '../widgets/remote_avatar.dart';

//Écran Profil : infos utilisateur, statistiques (échanges, compétences,
//note), compétences maîtrisées/recherchées, et switch thème clair/sombre.
//StatefulWidget car il doit RETENIR l'état du switch et se redessiner
//quand ThemeController notifie un changement.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = MockUsers.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              RemoteAvatar(
                imageUrl: user.avatarUrl,
                name: user.name,
                radius: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: theme.textTheme.titleMedium),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(user.location, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ],
                ),
              ),
              CustomButton(
                label: 'Modifier',
                isOutlined: true,
                isSmall: true,
                onPressed: () => context.pushNamed('editProfile'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          //--- Statistiques : Échanges / Compétences / Note ---
          Row(
            children: [
              _StatBlock(value: '${user.exchangesCount}', label: 'Échanges'),
              _StatBlock(
                value: '${user.skillsOffered.length}',
                label: 'Compétences',
              ),
              _StatBlock(value: user.rating.toStringAsFixed(1), label: 'Note'),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),

          Text('Je maîtrise', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: user.skillsOffered
                .map((s) => SkillChip(label: s))
                .toList(),
          ),
          const SizedBox(height: 20),

          Text('Je souhaite apprendre', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: user.skillsWanted
                .map((s) => SkillChip(label: s))
                .toList(),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),

          Text('À propos', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(user.bio, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),

          //--- Disponibilité ---
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 10,
                color: user.isAvailable
                    ? theme.colorScheme.primary
                    : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                user.isAvailable ? 'Disponible pour échanger' : 'Indisponible',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),

          //--- Switch thème clair/sombre : exigence de la consigne ---
          //ListenableBuilder écoute le ThemeController et redessine
          //UNIQUEMENT ce SwitchListTile quand le thème change, sans
          //avoir besoin de setState manuel dans cet écran.
          ListenableBuilder(
            listenable: ThemeController.instance,
            builder: (context, _) {
              return SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Thème sombre'),
                subtitle: Text(
                  ThemeController.instance.isDarkMode ? 'Activé' : 'Désactivé',
                ),
                value: ThemeController.instance.isDarkMode,
                onChanged: (value) =>
                    ThemeController.instance.setDarkMode(value),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 4,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.goNamed('home');
              break;
            case 1:
              context.goNamed('explore');
              break;
            case 2:
              context.goNamed('matches');
              break;
            case 3:
              context.goNamed('messages');
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

//Widget privé (utilisé uniquement dans ce fichier) pour afficher
//un bloc statistique (valeur + libellé), répété 3 fois dans la Row.
class _StatBlock extends StatelessWidget {
  final String value;
  final String label;

  const _StatBlock({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(value, style: theme.textTheme.headlineLarge),
          Text(label, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
