//Niveau de maîtrise d'une compétence. Un enum plutôt qu'une String
//libre évite les fautes de frappe et permet un filtrage fiable.
enum SkillLevel {
  beginner,
  intermediate,
  expert,
}

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
}