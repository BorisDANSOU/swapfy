import '../models/conversation.dart';
import '../models/message.dart';

abstract interface class MessagesRepository {
  String? get currentUserId;
  Stream<List<Conversation>> watchConversations();
  Stream<List<Message>> watchMessages(String conversationId);
  Future<String> openOrCreateConversation(String otherUserId);
  Future<void> sendMessage(String conversationId, String text);
}
