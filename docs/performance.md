# Profilage des performances

Les listes longues utilisent des builders Flutter. Les avatars réseau sont chargés à la demande par `CachedNetworkImage`, avec un placeholder, un fallback d'initiales et une taille de décodage limitée à la taille affichée.

## Vérification avant release

Le critère cible est un budget de frame de 16,7 ms sur un appareil 60 Hz. Une mesure doit être effectuée sur appareil physique ou émulateur en mode profile; les tests widget ne permettent pas de conclure sur le jank réel.

```bash
flutter run --profile -d <device-id>
```

Dans Flutter DevTools, ouvrir **Performance**, démarrer l'enregistrement, puis parcourir Home, Explore avec recherche et filtres, Matches, Messages et une conversation. Relever le nombre et le pourcentage de frames dépassant 16,7 ms, ainsi que le parcours concerné. Répéter le parcours au moins trois fois après un lancement à froid et une fois après le chargement des images.

Ne pas conclure à « 60 fps constant » à partir d'un build debug, d'un seul lancement ou d'une exécution de tests. Le présent dépôt fournit la procédure; aucune mesure matérielle n'est revendiquée par cette documentation.