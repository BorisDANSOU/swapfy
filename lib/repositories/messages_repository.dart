import '../models/conversation.dart';
import '../models/message.dart';

abstract interface class MessagesRepository {
  Stream<List<Conversation>> watchConversations();
  Stream<List<Message>> watchMessages(String conversationId);
  Future<void> sendMessage(String conversationId, String text);
}
