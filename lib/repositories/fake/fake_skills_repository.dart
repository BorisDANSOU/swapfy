import '../../data/skills.dart';
import '../../models/skill.dart';
import '../skills_repository.dart';

class FakeSkillsRepository implements SkillsRepository {
  final List<Skill> _skills;

  FakeSkillsRepository({List<Skill>? skills})
    : _skills = List.of(skills ?? MockSkills.skills);

  @override
  Stream<List<Skill>> watchSkills() async* {
    yield List.of(_skills);
  }

  @override
  Future<Skill?> getById(String id) async {
    for (final skill in _skills) {
      if (skill.id == id) return skill;
    }
    return null;
  }

  void dispose() {}
}
