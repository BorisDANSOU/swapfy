import '../models/skill.dart';

abstract interface class SkillsRepository {
  Stream<List<Skill>> watchSkills();
  Future<Skill?> getById(String id);
}
