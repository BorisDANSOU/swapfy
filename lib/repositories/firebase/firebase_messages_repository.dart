import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../models/conversation.dart';
import '../../models/message.dart';
import '../messages_repository.dart';

class FirebaseMessagesRepository implements MessagesRepository {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;

  FirebaseMessagesRepository({
    FirebaseFirestore? firestore,
    firebase_auth.FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _conversations =>
      _firestore.collection('conversations');

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  Stream<List<Conversation>> watchConversations() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value(const []);
    return _conversations
        .where('participantIds', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Conversation.fromMap(_withId(doc)))
              .toList(),
        );
  }

  @override
  Stream<List<Message>> watchMessages(String conversationId) {
    return _conversations
        .doc(conversationId)
        .collection('messages')
        .orderBy('sentAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Message.fromMap(_withId(doc)))
              .toList(),
        );
  }

  @override
  Future<String> openOrCreateConversation(String otherUserId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw StateError('A signed-in user is required.');
    if (userId == otherUserId) {
      throw ArgumentError.value(otherUserId, 'otherUserId');
    }

    final existing = await _conversations
        .where('participantIds', arrayContains: userId)
        .get();
    for (final document in existing.docs) {
      final participants = List<String>.from(
        document.data()['participantIds'] as List<dynamic>? ?? const [],
      );
      if (participants.length == 2 && participants.contains(otherUserId)) {
        return document.id;
      }
    }

    final reference = _conversations.doc();
    await reference.set({
      'participantIds': [userId, otherUserId]..sort(),
      'lastMessage': '',
      'updatedAt': Timestamp.now(),
    });
    return reference.id;
  }

  @override
  Future<void> sendMessage(String conversationId, String text) async {
    final normalizedText = text.trim();
    final senderId = _auth.currentUser?.uid;
    if (normalizedText.isEmpty || senderId == null) return;

    final messageReference = _conversations
        .doc(conversationId)
        .collection('messages')
        .doc();
    final sentAt = Timestamp.now();
    await messageReference.set({
      'id': messageReference.id,
      'conversationId': conversationId,
      'senderId': senderId,
      'text': normalizedText,
      'sentAt': sentAt,
      'isRead': false,
    });
    await _conversations.doc(conversationId).set({
      'lastMessage': normalizedText,
      'updatedAt': sentAt,
    }, SetOptions(merge: true));
  }

  Map<String, dynamic> _withId(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final sentAt = data['sentAt'];
    final updatedAt = data['updatedAt'];
    return {
      ...data,
      'id': doc.id,
      if (sentAt is Timestamp) 'sentAt': sentAt.toDate().toIso8601String(),
      if (updatedAt is Timestamp)
        'updatedAt': updatedAt.toDate().toIso8601String(),
    };
  }
}
