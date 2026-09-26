import 'package:flutter_test/flutter_test.dart';
import 'package:swapfy/models/conversation.dart';
import 'package:swapfy/models/message.dart';
import 'package:swapfy/models/skill.dart';
import 'package:swapfy/models/user.dart';

void main() {
  test('message round trips through a map', () {
    final original = Message(
      id: 'm1',
      conversationId: 'c1',
      senderId: 'u0',
      text: 'Bonjour',
      sentAt: DateTime.utc(2026, 9, 24, 12),
      isRead: true,
    );

    final restored = Message.fromMap(original.toMap());

    expect(restored.text, original.text);
    expect(restored.sentAt, original.sentAt);
    expect(restored.isRead, isTrue);
  });

  test('conversation round trips participant ids and timestamps', () {
    final original = Conversation(
      id: 'c1',
      participantIds: const ['u0', 'u1'],
      lastMessage: 'Salut',
      updatedAt: DateTime.utc(2026, 9, 24),
    );

    final restored = Conversation.fromMap(original.toMap());

    expect(restored.participantIds, original.participantIds);
    expect(restored.lastMessage, original.lastMessage);
    expect(restored.updatedAt, original.updatedAt);
  });

  test('skill round trips its enum level', () {
    const original = Skill(
      id: 's1',
      title: 'Flutter',
      description: 'UI toolkit',
      category: 'Dev',
      level: SkillLevel.intermediate,
      estimatedDuration: '3 weeks',
      wantedInExchange: 'Design',
      authorId: 'u0',
      studentsCount: 10,
    );

    final restored = Skill.fromMap(original.toMap());

    expect(restored.level, SkillLevel.intermediate);
    expect(restored.studentsCount, 10);
  });

  test('user accepts absent optional fields', () {
    final user = User.fromMap(const {'id': 'u1', 'name': 'Sarah'});

    expect(user.id, 'u1');
    expect(user.skillsOffered, isEmpty);
    expect(user.rating, 0);
    expect(user.isAvailable, isTrue);
    expect(user.skillLevel, SkillLevel.intermediate);
  });

  test('user profile persists its selected skill level', () {
    final user = User.fromMap(const {
      'id': 'u1',
      'name': 'Sarah',
      'skillLevel': 'expert',
    });

    expect(user.skillLevel, SkillLevel.expert);
    expect(
      user.copyWith(skillLevel: SkillLevel.beginner).toMap()['skillLevel'],
      'beginner',
    );
  });
}
