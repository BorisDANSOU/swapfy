# Swapfy Production-Ready Design

**Date:** 2026-09-24

## Goal

Porter Swapfy à un niveau production-ready en conservant les huit écrans existants, en ajoutant une persistance Firebase réelle, une authentification, une couverture de tests complète, l'internationalisation FR/EN, l'accessibilité, l'optimisation des performances et une CI reproductible.

## Scope

Le produit reste une application d'échange de compétences. Les fonctionnalités métier incluses sont :

- inscription, connexion et déconnexion ;
- profil utilisateur persistant ;
- consultation et recherche de compétences ;
- matches calculés depuis les données disponibles ;
- conversations et envoi de messages persistants ;
- changement de langue français/anglais ;
- thème clair/sombre conservé.

Les paiements, notifications push, modération avancée et appels vidéo restent hors périmètre de cette version.

## Architecture

L'application adopte une architecture par fonctionnalités légère, compatible avec la structure actuelle :

```text
lib/
  app/              # bootstrap Firebase, router, thème, localisation
  models/           # modèles immuables User, Skill, Message
  repositories/     # interfaces et implémentations Firebase/fake
  services/         # session et traduction si nécessaire
  data/             # fixtures de test et fallback de démonstration
  screens/          # écrans et états de présentation
  widgets/          # composants réutilisables accessibles
```

Les écrans ne lisent plus directement les listes mockées. Ils consomment des interfaces de repositories injectées au niveau de l'application et remplaçables dans les tests.

## Data and Firebase

Firebase Core initialise l'application sur chaque plateforme. Firebase Auth gère la session et Firestore stocke les données métier.

Collections Firestore :

- `users/{userId}` : identité publique, profil, compétences offertes/recherchées, disponibilité et statistiques ;
- `skills/{skillId}` : titre, description, catégorie, niveau, auteur et métadonnées ;
- `conversations/{conversationId}` : participants et dernier message ;
- `conversations/{conversationId}/messages/{messageId}` : auteur, contenu et horodatage.

Contrats principaux :

```dart
abstract interface class AuthRepository {
  Stream<User?> authStateChanges();
  Future<User> signIn(String email, String password);
  Future<User> register(String email, String password);
  Future<void> signOut();
}

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

Chaque interface possède une implémentation Firebase et une implémentation fake en mémoire. Les erreurs réseau sont transformées en états UI explicites et ne provoquent pas de crash.

## Navigation and State

GoRouter reste le routeur principal. Les routes publiques incluent l'authentification ; les routes applicatives sont redirigées vers `/login` lorsqu'aucune session Firebase n'est active. Les états `loading`, `error`, `empty` et `ready` sont représentés dans les écrans concernés.

Les providers ou contrôleurs restent limités aux états de présentation. Les données partagées sont exposées par les repositories, afin d'éviter les accès directs aux singletons mockés et de rendre les tests déterministes.

## Internationalization

`intl` et les fichiers ARB sont utilisés pour le français et l'anglais :

```text
l10n/
  app_fr.arb
  app_en.arb
```

Tous les textes visibles, messages d'erreur, labels d'accessibilité et libellés de navigation passent par les traductions générées. Le français est la langue par défaut, avec possibilité de basculer vers l'anglais depuis le profil ou les paramètres.

## Accessibility

Les contrôles interactifs utilisent les widgets Material sémantiques lorsque possible. Les éléments personnalisés reçoivent des `Semantics` explicites :

- boutons d'action avec un label et un état compréhensible ;
- avatars et images avec une description ou `excludeSemantics` si décoratifs ;
- chips de filtre avec état sélectionné ;
- navigation avec labels localisés ;
- champs de formulaire avec labels et erreurs accessibles ;
- messages de conversation distinguant auteur et contenu.

Les tests vérifieront les labels clés avec `SemanticsTester` ou des assertions de labels dans les tests widget.

## Performance

- Les listes utilisent `ListView.builder` ou `ListView.separated` lorsque le contenu est dynamique.
- Les images réseau utilisent `CachedNetworkImage`, une taille de cache bornée, un placeholder fixe et un fallback local.
- Les données constantes et les sous-arbres statiques utilisent `const`.
- Les contrôleurs et listeners sont libérés dans `dispose`.
- Les états locaux sont isolés pour éviter de reconstruire les écrans entiers lors d'une saisie ou d'un changement de thème.
- Une vérification de profilage en mode profile sera documentée ; aucun travail synchrone coûteux ne doit être exécuté dans `build`.

## Testing Strategy

La suite cible au minimum :

- 10 tests unitaires couvrant modèles, filtrage, tri, validation, contrôleurs et fake repositories ;
- 5 tests widget couvrant authentification, navigation principale, recherche, formulaire et conversation ;
- 2 tests d'intégration couvrant le parcours connexion -> accueil -> exploration et le parcours match -> conversation -> envoi ;
- tests en mode fake par défaut, sans accès réseau ni secrets Firebase dans la CI.

Les fixtures sont déterministes et les horodatages sont injectables. Les tests d'intégration utilisent une configuration Firebase Emulator lorsqu'elle est disponible ; sinon ils utilisent le bootstrap fake documenté pour la CI publique.

## CI/CD and Release

`.github/workflows/ci.yml` exécutera sur Windows ou Ubuntu avec une version Flutter fixée :

```text
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test integration_test
```

Les builds de démonstration sont séparés de la vérification obligatoire et nécessitent les secrets de signature uniquement dans les environnements protégés. Aucun fichier `google-services.json`, `GoogleService-Info.plist`, certificat ou secret n'est commité.

## Documentation and Versioning

Le README documentera :

- architecture et flux de données ;
- installation Flutter et configuration Firebase ;
- commandes de développement, test et build ;
- captures existantes et parcours principaux ;
- badges de statut CI ;
- limites connues et configuration des émulateurs.

`CHANGELOG.md` contiendra au minimum les versions `1.0.0`, `1.1.0` et `1.2.0`, avec une section `Added`, `Changed` ou `Fixed` pour chacune.

## Acceptance Criteria

La livraison est acceptée si :

1. l'application démarre et permet de parcourir au moins cinq écrans ;
2. l'authentification et les données Firebase fonctionnent avec une configuration locale valide ;
3. le mode fake permet d'exécuter toute la suite de tests sans réseau ;
4. `flutter analyze` ne produit aucun warning ni erreur ;
5. la CI exécute et réussit analyse, formatage et tests ;
6. les seuils 10 tests unitaires, 5 widget et 2 intégration sont atteints ;
7. les parcours principaux sont navigables au clavier/lecteur d'écran avec labels pertinents ;
8. le README, les captures, les badges et les trois versions du changelog sont présents ;
9. un APK de démonstration est généré si l'environnement Android et les secrets de build sont disponibles.