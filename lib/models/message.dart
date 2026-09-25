class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime sentAt;
  final bool isRead;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.sentAt,
    this.isRead = false,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      conversationId: map['conversationId'] as String,
      senderId: map['senderId'] as String,
      text: map['text'] as String,
      sentAt: DateTime.parse(map['sentAt'] as String),
      isRead: map['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'text': text,
      'sentAt': sentAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? text,
    DateTime? sentAt,
    bool? isRead,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
