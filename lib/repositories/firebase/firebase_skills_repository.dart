import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/skill.dart';
import '../skills_repository.dart';

class FirebaseSkillsRepository implements SkillsRepository {
  final FirebaseFirestore _firestore;

  FirebaseSkillsRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('skills');

  @override
  Stream<List<Skill>> watchSkills() {
    return _collection
        .where('published', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Skill.fromMap({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  @override
  Future<Skill?> getById(String id) async {
    final snapshot = await _collection.doc(id).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) return null;
    return Skill.fromMap({...data, 'id': snapshot.id});
  }
}
