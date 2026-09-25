import 'package:flutter_test/flutter_test.dart';
import 'package:swapfy/data/skills.dart';
import 'package:swapfy/data/users.dart';
import 'package:swapfy/models/skill.dart';

void main() {
  group('MockSkills', () {
    test('getById retourne la bonne competence', () {
      final skill = MockSkills.getById('1');
      expect(skill?.title, 'Flutter');
    });

    test('getById retourne null si id inexistant', () {
      final skill = MockSkills.getById('inexistant');
      expect(skill, isNull);
    });

    test('categories retourne des categories uniques', () {
      final categories = MockSkills.categories;
      expect(categories.toSet().length, categories.length);
    });
  });

  group('MockUsers', () {
    test('getById retourne le bon utilisateur', () {
      final user = MockUsers.getById('u1');
      expect(user?.name, 'Sarah K.');
    });

    test('matchesSortedByCompatibility exclut l\'utilisateur connecte', () {
      final matches = MockUsers.matchesSortedByCompatibility;
      expect(matches.any((u) => u.id == MockUsers.currentUserId), isFalse);
    });

    test('matchesSortedByCompatibility est bien triee', () {
      final matches = MockUsers.matchesSortedByCompatibility;
      for (var i = 0; i < matches.length - 1; i++) {
        expect(
          matches[i].compatibilityPercent >=
              matches[i + 1].compatibilityPercent,
          isTrue,
        );
      }
    });
  });

  group('SkillLevel', () {
    test('label retourne le bon texte pour chaque niveau', () {
      expect(SkillLevel.beginner.label, 'Débutant');
      expect(SkillLevel.intermediate.label, 'Intermédiaire');
      expect(SkillLevel.expert.label, 'Expert');
    });
  });
}
