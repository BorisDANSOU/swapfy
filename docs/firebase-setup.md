# Configuration Firebase

## Prérequis

- Flutter stable installé.
- Un projet Firebase créé pour Android, iOS ou Web.
- FlutterFire CLI installé avec `dart pub global activate flutterfire_cli`.

## Configuration locale

```text
flutterfire configure
flutter pub get
```

Activer ensuite Email/Password dans Firebase Authentication et créer une base Firestore. Déployer les règles et index depuis la racine du projet :

```text
firebase deploy --only firestore:rules,firestore:indexes
```

Les fichiers de configuration générés par FlutterFire et les secrets de signature ne doivent pas être commités dans un dépôt public. Firebase est obligatoire pour lancer l'application; les fake repositories sont réservés aux tests automatisés.

## GitHub Actions

Les workflows restaurent les fichiers Firebase depuis des secrets GitHub, car ces fichiers sont exclus de Git. Dans **Settings > Secrets and variables > Actions**, créer ces secrets de dépôt avec le contenu complet des fichiers locaux correspondants :

- `FIREBASE_OPTIONS_DART` : `lib/firebase_options.dart`.
- `GOOGLE_SERVICES_JSON` : `android/app/google-services.json`.

Les workflows échouent explicitement si l'un des secrets manque. Après avoir modifié la configuration Firebase, mettre à jour les secrets correspondants.
