class Conversation {
  final String id;
  final List<String> participantIds;
  final String? lastMessage;
  final DateTime? updatedAt;

  const Conversation({
    required this.id,
    required this.participantIds,
    this.lastMessage,
    this.updatedAt,
  });

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'] as String,
      participantIds: List<String>.from(map['participantIds'] as List<dynamic>),
      lastMessage: map['lastMessage'] as String?,
      updatedAt: map['updatedAt'] == null
          ? null
          : DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participantIds': participantIds,
      'lastMessage': lastMessage,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Conversation copyWith({
    String? id,
    List<String>? participantIds,
    String? lastMessage,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      lastMessage: lastMessage ?? this.lastMessage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
