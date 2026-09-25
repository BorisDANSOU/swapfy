import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../models/user.dart';
import '../users_repository.dart';

class FirebaseUsersRepository implements UsersRepository {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;

  FirebaseUsersRepository({
    FirebaseFirestore? firestore,
    firebase_auth.FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users');

  @override
  Stream<User?> watchCurrentUser() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value(null);
    return _collection.doc(userId).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (!snapshot.exists || data == null) return null;
      return User.fromMap({...data, 'id': snapshot.id});
    });
  }

  @override
  Stream<List<User>> watchMatches() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value(const []);
    return _collection
        .where(FieldPath.documentId, isNotEqualTo: userId)
        .orderBy('compatibilityPercent', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => User.fromMap({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  @override
  Future<void> saveProfile(User user) {
    return _collection.doc(user.id).set(user.toMap(), SetOptions(merge: true));
  }
}
