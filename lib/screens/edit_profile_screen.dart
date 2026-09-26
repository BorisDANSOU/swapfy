import 'package:flutter/material.dart';
import '../data/users.dart';
import '../l10n/app_localizations.dart';
import '../models/skill.dart';
import '../models/user.dart';
import '../repositories/users_repository.dart';
import '../widgets/custom_button.dart';
import '../widgets/remote_avatar.dart';
import 'package:go_router/go_router.dart';

//Écran de formulaire pour compléter/modifier son profil.
//StatefulWidget : indispensable avec un Form et des TextFormField,
//car Flutter doit pouvoir valider et lire les valeurs saisies via
//une GlobalKey<FormState>.
class EditProfileScreen extends StatefulWidget {
  final UsersRepository? usersRepository;

  const EditProfileScreen({super.key, this.usersRepository});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  //Relie ce State au widget Form plus bas : permet d'appeler
  //_formKey.currentState.validate() pour valider tous les champs d'un coup.
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  final TextEditingController _skillsOfferedController =
      TextEditingController();
  final TextEditingController _skillsWantedController = TextEditingController();

  SkillLevel _selectedLevel = SkillLevel.intermediate;
  bool _isAvailable = true;
  late User _currentUser;
  bool _isLoadingProfile = false;
  bool _profileMissing = false;

  @override
  void initState() {
    super.initState();
    //Pré-remplissage avec les données actuelles de Boris D., pour
    //simuler un vrai écran d'édition plutôt qu'un formulaire vide.
    _currentUser = MockUsers.currentUser;
    _nameController = TextEditingController(text: _currentUser.name);
    _bioController = TextEditingController(text: _currentUser.bio);
    _skillsOfferedController.text = _currentUser.skillsOffered.join(', ');
    _skillsWantedController.text = _currentUser.skillsWanted.join(', ');
    if (widget.usersRepository != null) _loadCurrentProfile();
  }

  Future<void> _loadCurrentProfile() async {
    setState(() => _isLoadingProfile = true);
    try {
      final user = await widget.usersRepository!.watchCurrentUser().first;
      if (!mounted) return;
      if (user != null) {
        _currentUser = user;
        _nameController.text = user.name;
        _bioController.text = user.bio;
        _skillsOfferedController.text = user.skillsOffered.join(', ');
        _skillsWantedController.text = user.skillsWanted.join(', ');
        _isAvailable = user.isAvailable;
        _selectedLevel = user.skillLevel;
      } else {
        _profileMissing = true;
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.loadProfileFailed),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoadingProfile = false);
    }
  }

  @override
  void dispose() {
    //On libère TOUS les contrôleurs créés, pour éviter les fuites mémoire.
    _nameController.dispose();
    _bioController.dispose();
    _skillsOfferedController.dispose();
    _skillsWantedController.dispose();
    super.dispose();
  }

  //Appelée quand l'utilisateur tape "Enregistrer mon profil".
  Future<void> _submitForm() async {
    //validate() exécute le validator de CHAQUE champ, et retourne true
    //seulement si TOUS les champs sont valides.
    if (_formKey.currentState!.validate()) {
      final updatedUser = _currentUser.copyWith(
        name: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        skillsOffered: _splitSkills(_skillsOfferedController.text),
        skillsWanted: _splitSkills(_skillsWantedController.text),
        isAvailable: _isAvailable,
        skillLevel: _selectedLevel,
      );
      try {
        await widget.usersRepository?.saveProfile(updatedUser);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.savedProfile)),
        );
        context.pop();
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.saveProfileFailed),
          ),
        );
      }
    }
    //Si validate() retourne false, Flutter affiche automatiquement les
    //messages d'erreur sous les champs invalides.
  }

  List<String> _splitSkills(String value) => value
      .split(',')
      .map((skill) => skill.trim())
      .where((skill) => skill.isNotEmpty)
      .toList();

  String _localizedLevel(AppLocalizations l10n, SkillLevel level) {
    return switch (level) {
      SkillLevel.beginner => l10n.beginner,
      SkillLevel.intermediate => l10n.intermediate,
      SkillLevel.expert => l10n.expert,
    };
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _currentUser;
    final l10n = AppLocalizations.of(context)!;

    if (_isLoadingProfile) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_profileMissing) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.editProfileTitle)),
        body: Center(child: Text(l10n.profileMissing)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfileTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: RemoteAvatar(
                imageUrl: currentUser.avatarUrl,
                name: currentUser.name,
                radius: 40,
              ),
            ),
            const SizedBox(height: 20),

            //--- Champ 1 : Nom (obligatoire) ---
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.nameLabel),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.requiredName;
                }
                if (value.trim().length < 2) {
                  return l10n.shortName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            //--- Champ 2 : Bio (obligatoire, longueur minimale) ---
            TextFormField(
              controller: _bioController,
              decoration: InputDecoration(labelText: l10n.bioLabel),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.requiredBio;
                }
                if (value.trim().length < 10) {
                  return l10n.shortBio;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            //--- Champ 3 : Compétences maîtrisées (obligatoire) ---
            TextFormField(
              controller: _skillsOfferedController,
              decoration: InputDecoration(
                labelText: l10n.skillsOfferedLabel,
                hintText: l10n.skillsOfferedHint,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.requiredOffered;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            //--- Champ 4 : Compétences recherchées (obligatoire) ---
            TextFormField(
              controller: _skillsWantedController,
              decoration: InputDecoration(
                labelText: l10n.skillsWantedLabel,
                hintText: l10n.skillsWantedHint,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.requiredWanted;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            //--- Champ 5 : Niveau (Dropdown) ---
            DropdownButtonFormField<SkillLevel>(
              initialValue: _selectedLevel,
              decoration: InputDecoration(labelText: l10n.skillLevel),
              items: SkillLevel.values
                  .map(
                    (level) => DropdownMenuItem(
                      value: level,
                      child: Text(_localizedLevel(l10n, level)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedLevel = value);
              },
            ),
            const SizedBox(height: 16),

            //--- Champ 6 : Disponibilité (switch) ---
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.availability),
              subtitle: Text(_isAvailable ? l10n.available : l10n.unavailable),
              value: _isAvailable,
              onChanged: (value) => setState(() => _isAvailable = value),
            ),
            const SizedBox(height: 24),

            CustomButton(label: l10n.saveProfile, onPressed: _submitForm),
          ],
        ),
      ),
    );
  }
}
