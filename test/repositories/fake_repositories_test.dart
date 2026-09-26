import 'package:flutter_test/flutter_test.dart';
import 'package:swapfy/data/skills.dart';
import 'package:swapfy/data/users.dart';
import 'package:swapfy/models/conversation.dart';
import 'package:swapfy/repositories/fake/fake_auth_repository.dart';
import 'package:swapfy/repositories/fake/fake_messages_repository.dart';
import 'package:swapfy/repositories/fake/fake_skills_repository.dart';
import 'package:swapfy/repositories/fake/fake_users_repository.dart';

void main() {
  test('fake auth starts signed out and signs in a known user', () async {
    final repository = FakeAuthRepository();

    expect(await repository.authStateChanges().first, isNull);

    final user = await repository.signIn('boris@example.com', 'password');

    expect(user.id, MockUsers.currentUserId);
    expect(await repository.authStateChanges().first, user);
    repository.dispose();
  });

  test('fake skills returns a copy of the fixture list', () async {
    final repository = FakeSkillsRepository();

    final skills = await repository.watchSkills().first;
    skills.clear();

    expect(MockSkills.skills, isNotEmpty);
    expect(await repository.getById('1'), isNotNull);
    repository.dispose();
  });

  test('fake users exposes current user and sorted matches', () async {
    final repository = FakeUsersRepository();

    expect(
      (await repository.watchCurrentUser().first)?.id,
      MockUsers.currentUserId,
    );
    expect((await repository.getById('u1'))?.id, 'u1');
    final matches = await repository.watchMatches().first;

    expect(matches, isNotEmpty);
    expect(
      matches.first.compatibilityPercent,
      greaterThanOrEqualTo(matches.last.compatibilityPercent),
    );
    repository.dispose();
  });

  test('fake user profile streams emit after a profile save', () async {
    final repository = FakeUsersRepository();
    final currentUser = (await repository.watchCurrentUser().first)!;
    final updates = <String>[];
    final subscription = repository.watchCurrentUser().listen(
      (user) => updates.add(user!.name),
    );
    await Future<void>.delayed(Duration.zero);

    await repository.saveProfile(currentUser.copyWith(name: 'Boris Updated'));
    await Future<void>.delayed(Duration.zero);

    expect(updates, ['Boris D.', 'Boris Updated']);
    await subscription.cancel();
    repository.dispose();
  });

  test('fake messages adds a message to a conversation', () async {
    final repository = FakeMessagesRepository(
      conversations: const [
        Conversation(id: 'conversation-1', participantIds: ['u0', 'u1']),
      ],
    );

    await repository.sendMessage('conversation-1', 'Bonjour');

    final messages = await repository.watchMessages('conversation-1').first;
    expect(messages, hasLength(1));
    expect(messages.single.text, 'Bonjour');
    expect(messages.single.senderId, MockUsers.currentUserId);
    expect(
      (await repository.watchConversations().first).single.lastMessage,
      'Bonjour',
    );
    repository.dispose();
  });

  test('fake messages ignores blank messages', () async {
    final repository = FakeMessagesRepository();

    await repository.sendMessage('conversation-1', '   ');

    expect(await repository.watchMessages('conversation-1').first, isEmpty);
    repository.dispose();
  });

  test(
    'fake messages reuses a conversation for the same participants',
    () async {
      final repository = FakeMessagesRepository();
      final emittedConversations = <List<Conversation>>[];
      final subscription = repository.watchConversations().listen(
        emittedConversations.add,
      );
      await Future<void>.delayed(Duration.zero);

      final firstId = await repository.openOrCreateConversation('u1');
      final secondId = await repository.openOrCreateConversation('u1');
      final conversations = await repository.watchConversations().first;
      await Future<void>.delayed(Duration.zero);

      expect(secondId, firstId);
      expect(conversations, hasLength(1));
      expect(conversations.single.participantIds, contains('u1'));
      expect(emittedConversations, hasLength(2));
      await subscription.cancel();
      repository.dispose();
    },
  );
}
