import 'dart:async';

import '../../data/users.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';
import '../messages_repository.dart';

class FakeMessagesRepository implements MessagesRepository {
  final List<Conversation> _conversations;
  final Map<String, List<Message>> _messages = {};
  final _changes = StreamController<String>.broadcast();
  int _nextMessageId = 0;

  FakeMessagesRepository({List<Conversation>? conversations})
    : _conversations = List.of(conversations ?? const []);

  @override
  Stream<List<Conversation>> watchConversations() async* {
    yield List.unmodifiable(_conversations);
  }

  @override
  Stream<List<Message>> watchMessages(String conversationId) async* {
    yield _copyMessages(conversationId);
    yield* _changes.stream
        .where((changedId) => changedId == conversationId)
        .map((_) => _copyMessages(conversationId));
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
    _changes.add(conversationId);
  }

  List<Message> _copyMessages(String conversationId) {
    return List.unmodifiable(_messages[conversationId] ?? const []);
  }

  void dispose() {
    _changes.close();
  }
}
