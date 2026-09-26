# Changelog

## [Unreleased]

### Added

- Profils, compétences, conversations et messages branchés aux repositories Firestore.
- Localisation FR/EN des parcours principaux et sélecteur de langue dans le profil.
- États de chargement/erreur, persistance des modifications de profil et protocole de profilage 60 Hz.

### Fixed

- Les messages utilisent l'identifiant de conversation et le flux de données persisté.
- Les parcours d'intégration utilisent des attentes déterministes et des repositories fake partagés.
- Les listes Explore construisent leurs lignes à la demande et les avatars limitent leur taille de décodage.

## [1.2.0] - 2026-09-24

### Added

- Firebase Auth et Firestore avec repositories injectables.
- Internationalisation française et anglaise.
- CI Flutter avec analyse, formatage et tests.

### Changed

- Avatars réseau avec cache et fallback d'initiales.
- Contrôles personnalisés enrichis en sémantique.

## [1.1.0] - 2026-09-24

### Added

- Navigation GoRouter, matches, messagerie et édition de profil.
- Thème clair/sombre et données de démonstration structurées.

## [1.0.0] - 2026-09-24

### Added

- Première version Swapfy avec accueil, exploration, compétences et profil.
