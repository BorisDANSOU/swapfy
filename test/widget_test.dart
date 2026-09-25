import 'package:flutter_test/flutter_test.dart';
import 'package:swapfy/app/router.dart';
import 'package:swapfy/app/theme.dart';
import 'package:swapfy/data/skills.dart';
import 'package:swapfy/data/users.dart';
import 'package:swapfy/repositories/fake/fake_auth_repository.dart';
import 'package:swapfy/repositories/fake/fake_messages_repository.dart';
import 'package:flutter/material.dart';

//Tests de configuration de base : on vérifie que les éléments
//essentiels de l'application (router, thème, données) sont bien
//initialisés, sans passer par le rendu graphique complet (qui
//dépend d'images réseau non disponibles en environnement de test).
void main() {
  test('Le router contient bien des routes configurées', () {
    final router = AppRouter(
      instanceAuthRepository: FakeAuthRepository(),
      instanceMessagesRepository: FakeMessagesRepository(),
    );
    expect(router.goRouter.configuration.routes, isNotEmpty);
  });

  test('Le theme clair est correctement configure', () {
    expect(AppTheme.lightTheme.brightness, equals(Brightness.light));
  });

  test('Le theme sombre est correctement configure', () {
    expect(AppTheme.darkTheme.brightness, equals(Brightness.dark));
  });

  test('Les donnees de competences ne sont pas vides', () {
    expect(MockSkills.skills, isNotEmpty);
  });

  test('Les donnees utilisateurs ne sont pas vides', () {
    expect(MockUsers.users, isNotEmpty);
  });
}
