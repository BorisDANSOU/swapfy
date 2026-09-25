# Swapfy Production-Ready Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transformer Swapfy en application Flutter production-ready avec Firebase, authentification, données persistantes, i18n FR/EN, accessibilité, tests automatisés et CI/CD.

**Architecture:** Les écrans existants restent la surface UI, mais consomment des interfaces de repositories injectées. Les implémentations Firebase servent la production et les fake repositories servent les tests et le mode démonstration sans réseau. GoRouter protège les routes privées à partir de l'état d'authentification.

**Tech Stack:** Flutter/Dart 3.12.2, Material 3, GoRouter 14.6.2, Firebase Core/Auth/Firestore, `intl`, `flutter_localizations`, `cached_network_image`, Flutter test et integration_test, GitHub Actions.

## Global Constraints

- Conserver les huit écrans et les routes métier existantes.
- Supporter le français et l'anglais, avec le français comme langue par défaut.
- Ne jamais commiter `google-services.json`, `GoogleService-Info.plist`, certificats ou secrets.
- Maintenir un mode fake exécutable sans réseau pour la CI et les tests.
- Atteindre au minimum 10 tests unitaires, 5 tests widget et 2 tests d'intégration.
- `dart format --output=none --set-exit-if-changed .` et `flutter analyze` doivent réussir.
- Ne pas ajouter de dépendance Firebase avant d'avoir confirmé les versions compatibles avec le SDK Flutter installé.

---

### Task 1: Stabiliser les dépendances et les contrats de données

**Files:**
- Modify: `pubspec.yaml`
- Modify: `analysis_options.yaml`
- Create: `lib/models/message.dart`
- Create: `lib/models/conversation.dart`
- Create: `lib/repositories/auth_repository.dart`
- Create: `lib/repositories/skills_repository.dart`
- Create: `lib/repositories/users_repository.dart`
- Create: `lib/repositories/messages_repository.dart`
- Create: `lib/repositories/fake/fake_auth_repository.dart`
- Create: `lib/repositories/fake/fake_skills_repository.dart`
- Create: `lib/repositories/fake/fake_users_repository.dart`
- Create: `lib/repositories/fake/fake_messages_repository.dart`
- Test: `test/repositories/fake_repositories_test.dart`

**Interfaces:**
- Les repositories exposent des `Stream` pour les données observables et des `Future` pour les mutations.
- Les modèles `Message` et `Conversation` sont immuables et possèdent `fromMap`/`toMap` pour Firestore.
- Les fake repositories réutilisent les fixtures de `lib/data/` sans effectuer d'accès réseau.

- [ ] **Step 1: Ajouter les dépendances nécessaires**

Exécuter dans le projet :

```text
flutter pub add firebase_core firebase_auth cloud_firestore intl flutter_localizations cached_network_image
flutter pub add --dev integration_test
```

Vérifier que les versions résolues sont compatibles avec le SDK du projet avant de poursuivre.

- [ ] **Step 2: Écrire les tests des fake repositories**

Tester au minimum : session initiale absente, inscription simulée, récupération des compétences, recherche par id, tri des matches, lecture d'une conversation et ajout d'un message.

Exemple de comportement attendu :

```dart
test('sendMessage ajoute un message à la conversation', () async {
  final repository = FakeMessagesRepository();

  await repository.sendMessage('conversation-1', 'Bonjour');

  expect(
    repository.watchMessages('conversation-1'),
    emits(predicate<List<Message>>((messages) => messages.last.text == 'Bonjour')),
  );
});
```

- [ ] **Step 3: Implémenter les modèles et contrats**

Utiliser les signatures suivantes :

```dart
abstract interface class SkillsRepository {
  Stream<List<Skill>> watchSkills();
  Future<Skill?> getById(String id);
}

abstract interface class UsersRepository {
  Stream<User?> watchCurrentUser();
  Stream<List<User>> watchMatches();
  Future<void> saveProfile(User user);
}

abstract interface class MessagesRepository {
  Stream<List<Conversation>> watchConversations();
  Stream<List<Message>> watchMessages(String conversationId);
  Future<void> sendMessage(String conversationId, String text);
}
```

- [ ] **Step 4: Implémenter les fake repositories**

Utiliser des `StreamController.broadcast()` ou des `ValueNotifier` encapsulés, fermer toutes les ressources dans `dispose`, et ne jamais muter directement les fixtures globales.

- [ ] **Step 5: Valider le lot**

```text
dart format lib/models lib/repositories test/repositories
flutter test test/repositories/fake_repositories_test.dart
flutter analyze
```

- [ ] **Step 6: Commit**

```text
git add pubspec.yaml pubspec.lock analysis_options.yaml lib/models lib/repositories test/repositories
git commit -m "feat: add repository contracts and fake data sources"
```

### Task 2: Initialiser Firebase et ajouter l'authentification

**Files:**
- Create: `lib/app/firebase_bootstrap.dart`
- Create: `lib/services/session_service.dart`
- Create: `lib/repositories/firebase/firebase_auth_repository.dart`
- Create: `lib/repositories/firebase/firebase_skills_repository.dart`
- Create: `lib/repositories/firebase/firebase_users_repository.dart`
- Create: `lib/repositories/firebase/firebase_messages_repository.dart`
- Create: `lib/screens/auth/login_screen.dart`
- Create: `lib/screens/auth/register_screen.dart`
- Modify: `lib/main.dart`
- Modify: `lib/app/router.dart`
- Create: `test/services/session_service_test.dart`
- Create: `test/screens/auth/login_screen_test.dart`

**Prerequisite:** Un projet Firebase doit exister et l'utilisateur doit pouvoir exécuter `flutterfire configure`. La configuration générée localement reste ignorée par Git si elle contient des valeurs propres à l'environnement.

- [ ] **Step 1: Écrire les tests de session et de connexion**

Vérifier que l'état initial affiche un chargement, qu'une erreur de connexion est localisée, qu'une connexion réussie redirige vers `/`, et qu'un utilisateur non authentifié est redirigé vers `/login`.

- [ ] **Step 2: Configurer Firebase**

Exécuter :

```text
dart pub global activate flutterfire_cli
flutterfire configure
```

Créer `firebase_options.dart` uniquement via l'outil FlutterFire et documenter la procédure dans le README.

- [ ] **Step 3: Initialiser Firebase avant `runApp`**

`lib/main.dart` doit appeler `WidgetsFlutterBinding.ensureInitialized()`, initialiser Firebase, construire les repositories et injecter le mode Firebase ou fake selon une configuration explicite.

- [ ] **Step 4: Implémenter `FirebaseAuthRepository` et `SessionService`**

Mapper les erreurs Firebase Auth vers des exceptions applicatives stables : identifiants invalides, email déjà utilisé, mot de passe faible et erreur réseau.

- [ ] **Step 5: Ajouter les écrans Login/Register**

Les formulaires doivent avoir des labels, validation locale, états de soumission désactivés, messages d'erreur accessibles et navigation vers l'écran opposé.

- [ ] **Step 6: Ajouter la redirection GoRouter**

Utiliser une source de session observable. Les routes `/login` et `/register` restent publiques ; `/`, `/explore`, `/matches`, `/messages`, `/profile` et leurs routes enfants sont privées.

- [ ] **Step 7: Valider le lot**

```text
dart format lib/app lib/services lib/repositories/firebase lib/screens/auth test
flutter test test/services/session_service_test.dart test/screens/auth/login_screen_test.dart
flutter analyze
```

- [ ] **Step 8: Commit**

```text
git add lib pubspec.yaml pubspec.lock test
git commit -m "feat: add Firebase authentication and protected routes"
```

### Task 3: Migrer les données métier vers Firestore

**Files:**
- Modify: `lib/repositories/firebase/firebase_skills_repository.dart`
- Modify: `lib/repositories/firebase/firebase_users_repository.dart`
- Modify: `lib/repositories/firebase/firebase_messages_repository.dart`
- Create: `firestore.rules`
- Create: `firestore.indexes.json`
- Create: `test/repositories/firebase_mapping_test.dart`
- Modify: `lib/screens/home_screen.dart`
- Modify: `lib/screens/explore_screen.dart`
- Modify: `lib/screens/matches_screen.dart`
- Modify: `lib/screens/messages_screen.dart`
- Modify: `lib/screens/conversation_screen.dart`
- Modify: `lib/screens/profile_screen.dart`
- Modify: `lib/screens/skill_detail_screen.dart`
- Modify: `lib/screens/edit_profile_screen.dart`

- [ ] **Step 1: Écrire les tests de mapping Firestore**

Tester les conversions Map -> modèle et modèle -> Map, les valeurs manquantes, les timestamps et les listes vides sans utiliser Firestore réel.

- [ ] **Step 2: Implémenter les repositories Firestore**

Utiliser des snapshots typés, limiter les champs lus avec des projections lorsque possible, et convertir les exceptions en erreurs applicatives. Les flux doivent être annulés/libérés par le cycle de vie du widget consommateur.

- [ ] **Step 3: Ajouter les règles Firestore**

Autoriser la lecture des compétences publiées, limiter la lecture/écriture des profils à l'utilisateur concerné, et autoriser les messages uniquement aux participants de la conversation. Refuser par défaut tout chemin non documenté.

- [ ] **Step 4: Remplacer les accès directs à `MockSkills` et `MockUsers`**

Chaque écran doit recevoir ou lire son repository via la composition racine. Ajouter des états `loading`, `error`, `empty` et `ready` visibles et localisés.

- [ ] **Step 5: Préserver les routes dynamiques**

`/skill/:id` doit afficher un état d'absence pour un id inconnu. `/messages/:userId` doit résoudre la conversation ou afficher une erreur récupérable.

- [ ] **Step 6: Valider le lot**

```text
flutter test test/repositories/firebase_mapping_test.dart
flutter test
flutter analyze
```

- [ ] **Step 7: Commit**

```text
git add lib firestore.rules firestore.indexes.json test
git commit -m "feat: persist skills profiles and messages with Firestore"
```

### Task 4: Ajouter l'internationalisation et le sélecteur de langue

**Files:**
- Modify: `pubspec.yaml`
- Modify: `lib/main.dart`
- Create: `l10n/app_fr.arb`
- Create: `l10n/app_en.arb`
- Create: `lib/app/locale_controller.dart`
- Modify: `lib/screens/**/*.dart`
- Modify: `lib/widgets/**/*.dart`
- Create: `test/l10n/localization_test.dart`

- [ ] **Step 1: Écrire le test de présence des traductions**

Vérifier que le français et l'anglais exposent les clés des titres de routes, boutons, états d'erreur, formulaires, navigation et labels sémantiques.

- [ ] **Step 2: Configurer `flutter_localizations` et les ARB**

Déclarer les locales `fr` et `en`, le français par défaut et la génération localisée dans `l10n.yaml`.

- [ ] **Step 3: Migrer tous les textes visibles**

Remplacer les chaînes directes des écrans et widgets par `AppLocalizations.of(context)!`. Les textes générés dynamiquement utilisent les paramètres ARB plutôt que la concaténation.

- [ ] **Step 4: Ajouter le contrôle de langue au profil**

Le changement de langue doit mettre à jour `MaterialApp` sans redémarrage et persister le choix localement si le stockage local est ajouté.

- [ ] **Step 5: Valider le lot**

```text
flutter gen-l10n
flutter test test/l10n/localization_test.dart
flutter analyze
```

- [ ] **Step 6: Commit**

```text
git add pubspec.yaml l10n.yaml l10n lib test/l10n
git commit -m "feat: add French and English localization"
```

### Task 5: Durcir l'accessibilité et les performances UI

**Files:**
- Modify: `lib/widgets/custom_button.dart`
- Modify: `lib/widgets/skill_chip.dart`
- Modify: `lib/widgets/user_card.dart`
- Modify: `lib/widgets/match_card.dart`
- Modify: `lib/widgets/search_bar.dart`
- Modify: `lib/screens/**/*.dart`
- Create: `test/accessibility/widgets_semantics_test.dart`

- [ ] **Step 1: Écrire les tests sémantiques**

Vérifier les labels des actions principales, les labels des destinations de navigation, l'état sélectionné des filtres et la description des images/avatar.

- [ ] **Step 2: Remplacer les interactions non sémantiques**

Remplacer les `GestureDetector` interactifs par `Semantics` + `InkWell`/`IconButton` lorsque cela préserve le comportement, ou fournir une configuration `Semantics(button: true, label: ...)` complète.

- [ ] **Step 3: Ajouter les états d'image robustes**

Créer un widget partagé `lib/widgets/remote_avatar.dart` basé sur `CachedNetworkImage`, avec dimension stable, placeholder local, fallback d'initiales et texte sémantique.

- [ ] **Step 4: Réduire les rebuilds inutiles**

Conserver les sous-arbres constants en `const`, isoler les écouteurs de thème/session, utiliser les builders de liste et déplacer les calculs de filtrage hors de `build` lorsque le contrôleur change.

- [ ] **Step 5: Valider le lot**

```text
flutter test test/accessibility/widgets_semantics_test.dart
flutter analyze
flutter run --profile
```

Inspecter les parcours Home, Explore, Matches et Conversation en mode profile et vérifier l'absence de travail lourd dans `build` et de dépassements de frame visibles.

- [ ] **Step 6: Commit**

```text
git add lib test/accessibility
git commit -m "fix: improve accessibility and image rendering"
```

### Task 6: Compléter les tests unitaires, widget et intégration

**Files:**
- Modify: `test/models_test.dart`
- Modify: `test/widget_test.dart`
- Create: `test/controllers/theme_controller_test.dart`
- Create: `test/screens/explore_screen_test.dart`
- Create: `test/screens/profile_screen_test.dart`
- Create: `test/screens/conversation_screen_test.dart`
- Create: `integration_test/auth_navigation_test.dart`
- Create: `integration_test/messaging_flow_test.dart`
- Create: `integration_test/test_app.dart`

- [ ] **Step 1: Atteindre 10 tests unitaires**

Ajouter des tests pour validation de profil, niveau de compétence, filtrage insensible à la casse, tri des matches, recherche id, thème, fake auth, fake skills, fake users et fake messages.

- [ ] **Step 2: Atteindre 5 tests widget**

Tester le rendu et le comportement de Login, Home/navigation, Explore/recherche, EditProfile/validation et Conversation/envoi. Injecter les fake repositories et éviter tout réseau.

- [ ] **Step 3: Ajouter le harnais d'intégration**

Créer `test_app.dart` qui initialise l'application avec des repositories fake et une session de test contrôlée.

- [ ] **Step 4: Écrire le parcours d'authentification/navigation**

Démarrer déconnecté, se connecter, vérifier l'accès à Home, ouvrir Explore et ouvrir le détail d'une compétence.

- [ ] **Step 5: Écrire le parcours messaging**

Ouvrir un match, entrer dans la conversation, envoyer un texte non vide et vérifier son affichage, puis vérifier que l'envoi vide est ignoré.

- [ ] **Step 6: Valider les seuils**

```text
flutter test
flutter test integration_test
flutter analyze
```

- [ ] **Step 7: Commit**

```text
git add test integration_test
git commit -m "test: cover repositories widgets and user flows"
```

### Task 7: Configurer CI/CD et la documentation de livraison

**Files:**
- Create: `.github/workflows/ci.yml`
- Create: `.github/workflows/build-android.yml`
- Create: `CHANGELOG.md`
- Modify: `README.md`
- Modify: `.gitignore`
- Create: `docs/firebase-setup.md`

- [ ] **Step 1: Écrire le workflow CI**

Le workflow doit utiliser une version Flutter fixée et exécuter :

```text
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test integration_test
```

Les tests doivent fonctionner en mode fake et ne pas exiger de secrets Firebase.

- [ ] **Step 2: Ajouter le build Android optionnel**

Déclencher le build APK sur tag ou manuellement. Séparer les secrets de signature du job de test. Publier l'APK comme artifact uniquement si la configuration Android est disponible.

- [ ] **Step 3: Rédiger la documentation Firebase**

Décrire la création du projet, l'activation Auth/Firestore, `flutterfire configure`, les règles, le mode fake et les émulateurs locaux.

- [ ] **Step 4: Mettre à jour le README**

Ajouter badges CI, architecture, prérequis, commandes `flutter run`, `flutter test`, `flutter test integration_test`, configuration Firebase, captures existantes, limitations et builds.

- [ ] **Step 5: Ajouter le changelog**

Documenter au minimum :

```markdown
## [1.2.0] - 2026-09-24
### Added
- Firebase Auth, Firestore, internationalisation et CI production-ready.

## [1.1.0] - 2026-09-24
### Added
- Navigation GoRouter, matches, messagerie et édition de profil.

## [1.0.0] - 2026-09-24
### Added
- Première version Swapfy avec écrans de découverte et profil.
```

- [ ] **Step 6: Valider comme la CI**

```text
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test integration_test
```

- [ ] **Step 7: Commit**

```text
git add .github CHANGELOG.md README.md .gitignore docs/firebase-setup.md
git commit -m "ci: add production checks and release documentation"
```

### Task 8: Validation finale et préparation de livraison

**Files:**
- Modify: `README.md` if validation reveals stale commands or paths
- Modify: `CHANGELOG.md` if release notes need final corrections

- [ ] **Step 1: Vérifier les changements non suivis et les secrets**

```text
git status --short
git grep -n "AIza\|private_key\|client_secret" -- ':!pubspec.lock'
```

Le grep ne doit trouver aucun secret réel.

- [ ] **Step 2: Exécuter toute la validation locale**

```text
flutter clean
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test integration_test
flutter build apk --debug
```

- [ ] **Step 3: Vérifier les parcours manuellement**

Tester connexion, déconnexion, exploration, filtre, détail, match, conversation, envoi, profil, changement de thème et changement de langue sur une taille mobile et une taille tablette.

- [ ] **Step 4: Vérifier la CI et l'artifact Android**

Pousser sur une branche de travail, confirmer que le workflow est vert et que l'artifact APK est téléchargeable lorsque le job de build est activé.

- [ ] **Step 5: Produire le rapport de livraison**

Noter dans le README ou la release : commit validé, version Flutter, résultats des commandes, limites Firebase connues et disponibilité de l'APK. Ne pas prétendre à une IPA si aucun environnement macOS et aucun certificat iOS ne sont disponibles.

## Final Acceptance Checklist

- [ ] Au moins cinq écrans fonctionnels et routés.
- [ ] Firebase Auth et Firestore configurés et testables.
- [ ] Mode fake sans réseau pour CI.
- [ ] Au moins 10 tests unitaires.
- [ ] Au moins 5 tests widget.
- [ ] Au moins 2 tests d'intégration.
- [ ] `flutter analyze` propre.
- [ ] Formatage vérifié.
- [ ] Labels sémantiques sur les interactions.
- [ ] FR et EN disponibles.
- [ ] Images lazy-loadées, avec cache et fallback.
- [ ] Rebuilds inutiles réduits.
- [ ] CI GitHub Actions active.
- [ ] README professionnel avec badges et captures.
- [ ] CHANGELOG avec trois versions.
- [ ] APK généré si l'environnement le permet.