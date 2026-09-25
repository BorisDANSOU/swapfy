//Niveau de maîtrise d'une compétence. Un enum plutôt qu'une String
//libre évite les fautes de frappe et permet un filtrage fiable.
enum SkillLevel { beginner, intermediate, expert }

//Extension ajoutant un getter pratique pour afficher le niveau
//en français, centralisé en un seul endroit.
extension SkillLevelLabel on SkillLevel {
  String get label {
    switch (this) {
      case SkillLevel.beginner:
        return 'Débutant';
      case SkillLevel.intermediate:
        return 'Intermédiaire';
      case SkillLevel.expert:
        return 'Expert';
    }
  }
}

//Modèle représentant une compétence proposée sur Swapfy.
class Skill {
  final String id;
  final String title;
  final String description;
  final String category;
  final SkillLevel level;
  final String estimatedDuration;
  final String wantedInExchange;
  final String authorId;
  final int studentsCount;
  final List<String> associatedSkills;

  const Skill({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    required this.estimatedDuration,
    required this.wantedInExchange,
    required this.authorId,
    required this.studentsCount,
    this.associatedSkills = const [],
  });

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      level: SkillLevel.values.byName(map['level'] as String),
      estimatedDuration: map['estimatedDuration'] as String,
      wantedInExchange: map['wantedInExchange'] as String,
      authorId: map['authorId'] as String,
      studentsCount: map['studentsCount'] as int,
      associatedSkills: List<String>.from(
        map['associatedSkills'] as List<dynamic>? ?? const [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'level': level.name,
      'estimatedDuration': estimatedDuration,
      'wantedInExchange': wantedInExchange,
      'authorId': authorId,
      'studentsCount': studentsCount,
      'associatedSkills': associatedSkills,
    };
  }
}
