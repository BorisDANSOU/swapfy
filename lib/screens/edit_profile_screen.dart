import 'package:flutter/material.dart';
import '../data/users.dart';
import '../widgets/custom_button.dart';
import '../widgets/remote_avatar.dart';
import 'package:go_router/go_router.dart';

//Écran de formulaire pour compléter/modifier son profil.
//StatefulWidget : indispensable avec un Form et des TextFormField,
//car Flutter doit pouvoir valider et lire les valeurs saisies via
//une GlobalKey<FormState>.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

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

  String _selectedLevel = 'Intermédiaire';
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    //Pré-remplissage avec les données actuelles de Boris D., pour
    //simuler un vrai écran d'édition plutôt qu'un formulaire vide.
    final currentUser = MockUsers.currentUser;
    _nameController = TextEditingController(text: currentUser.name);
    _bioController = TextEditingController(text: currentUser.bio);
    _skillsOfferedController.text = currentUser.skillsOffered.join(', ');
    _skillsWantedController.text = currentUser.skillsWanted.join(', ');
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
  void _submitForm() {
    //validate() exécute le validator de CHAQUE champ, et retourne true
    //seulement si TOUS les champs sont valides.
    if (_formKey.currentState!.validate()) {
      //Dans une vraie app, on sauvegarderait ici (base de données/API).
      //Pour cette démo, on confirme juste visuellement.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil enregistré avec succès !')),
      );

      (context).pop();
    }
    //Si validate() retourne false, Flutter affiche automatiquement les
    //messages d'erreur sous les champs invalides.
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = MockUsers.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Compléter mon profil')),
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
              decoration: const InputDecoration(labelText: 'Nom *'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le nom est obligatoire';
                }
                if (value.trim().length < 2) {
                  return 'Le nom doit contenir au moins 2 caractères';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            //--- Champ 2 : Bio (obligatoire, longueur minimale) ---
            TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: 'Bio *'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La bio est obligatoire';
                }
                if (value.trim().length < 10) {
                  return 'La bio doit contenir au moins 10 caractères';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            //--- Champ 3 : Compétences maîtrisées (obligatoire) ---
            TextFormField(
              controller: _skillsOfferedController,
              decoration: const InputDecoration(
                labelText: 'Compétences maîtrisées *',
                hintText: 'Ex: Flutter, Python',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Indique au moins une compétence';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            //--- Champ 4 : Compétences recherchées (obligatoire) ---
            TextFormField(
              controller: _skillsWantedController,
              decoration: const InputDecoration(
                labelText: 'Compétences recherchées *',
                hintText: 'Ex: React, Anglais',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Indique au moins une compétence recherchée';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            //--- Champ 5 : Niveau (Dropdown) ---
            DropdownButtonFormField<String>(
              initialValue: _selectedLevel,
              decoration: const InputDecoration(labelText: 'Niveau'),
              items: ['Débutant', 'Intermédiaire', 'Expert']
                  .map(
                    (level) =>
                        DropdownMenuItem(value: level, child: Text(level)),
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
              title: const Text('Disponibilité'),
              subtitle: Text(_isAvailable ? 'Disponible' : 'Indisponible'),
              value: _isAvailable,
              onChanged: (value) => setState(() => _isAvailable = value),
            ),
            const SizedBox(height: 24),

            CustomButton(
              label: 'Enregistrer mon profil',
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }
}
