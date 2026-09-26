import 'dart:async';

import '../../data/users.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';
import '../messages_repository.dart';

class FakeMessagesRepository implements MessagesRepository {
  final List<Conversation> _conversations;
  final Map<String, List<Message>> _messages = {};
  final _changes = StreamController<String>.broadcast();
  final _conversationChanges = StreamController<List<Conversation>>.broadcast();
  int _nextMessageId = 0;

  FakeMessagesRepository({List<Conversation>? conversations})
    : _conversations = List.of(conversations ?? const []);

  @override
  String get currentUserId => MockUsers.currentUserId;

  @override
  Stream<List<Conversation>> watchConversations() async* {
    yield List.unmodifiable(_conversations);
    yield* _conversationChanges.stream;
  }

  @override
  Stream<List<Message>> watchMessages(String conversationId) async* {
    yield _copyMessages(conversationId);
    yield* _changes.stream
        .where((changedId) => changedId == conversationId)
        .map((_) => _copyMessages(conversationId));
  }

  @override
  Future<String> openOrCreateConversation(String otherUserId) async {
    final existing = _conversations.where(
      (conversation) =>
          conversation.participantIds.contains(MockUsers.currentUserId) &&
          conversation.participantIds.contains(otherUserId),
    );
    if (existing.isNotEmpty) return existing.first.id;

    final participants = [MockUsers.currentUserId, otherUserId]..sort();
    final conversationId = 'conversation-${participants.join('-')}';
    _conversations.add(
      Conversation(id: conversationId, participantIds: participants),
    );
    _conversationChanges.add(List.unmodifiable(_conversations));
    return conversationId;
  }

  @override
  Future<void> sendMessage(String conversationId, String text) async {
    final normalizedText = text.trim();
    if (normalizedText.isEmpty) return;

    final message = Message(
      id: 'message-${_nextMessageId++}',
      conversationId: conversationId,
      senderId: MockUsers.currentUserId,
      text: normalizedText,
      sentAt: DateTime.now(),
    );
    _messages.putIfAbsent(conversationId, () => []).add(message);
    final conversationIndex = _conversations.indexWhere(
      (conversation) => conversation.id == conversationId,
    );
    if (conversationIndex != -1) {
      _conversations[conversationIndex] = _conversations[conversationIndex]
          .copyWith(lastMessage: normalizedText, updatedAt: message.sentAt);
      _conversationChanges.add(List.unmodifiable(_conversations));
    }
    _changes.add(conversationId);
  }

  List<Message> _copyMessages(String conversationId) {
    return List.unmodifiable(_messages[conversationId] ?? const []);
  }

  void dispose() {
    _changes.close();
    _conversationChanges.close();
  }
}
