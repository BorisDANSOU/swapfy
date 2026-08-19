import '../models/skill.dart';

//Données de démonstration pour les compétences proposées sur Swapfy.
//Chaque compétence référence son auteur via authorId (voir users.dart).
class MockSkills {
  static final List<Skill> skills = [
    const Skill(
      id: '1',
      title: 'Flutter',
      description:
          'Flutter est le toolkit UI de Google pour créer de belles '
          'applications nativement compilées pour mobile, web et desktop '
          'à partir d\'une seule base de code.',
      category: 'Développement',
      level: SkillLevel.intermediate,
      estimatedDuration: '3 semaines',
      wantedInExchange: 'UI/UX Design',
      authorId: 'u0', // Boris D.
      studentsCount: 142,
      associatedSkills: ['Dart', 'Mobile UI', 'State Management'],
    ),
    const Skill(
      id: '2',
      title: 'Python',
      description:
          'Apprends les bases du langage Python : variables, boucles, '
          'fonctions, et une introduction à la data science.',
      category: 'Développement',
      level: SkillLevel.beginner,
      estimatedDuration: '2 semaines',
      wantedInExchange: 'Flutter',
      authorId: 'u2', // Alex M.
      studentsCount: 126,
      associatedSkills: ['Data Science', 'Automatisation'],
    ),
    const Skill(
      id: '3',
      title: 'JavaScript',
      description:
          'Maîtrise les fondamentaux de JavaScript moderne : ES6+, '
          'programmation asynchrone, manipulation du DOM.',
      category: 'Développement',
      level: SkillLevel.beginner,
      estimatedDuration: '2 semaines',
      wantedInExchange: 'Python',
      authorId: 'u3', // John D.
      studentsCount: 104,
      associatedSkills: ['React', 'Node.js'],
    ),
    const Skill(
      id: '4',
      title: 'UI/UX Design',
      description:
          'Découvre les principes fondamentaux du design d\'interface : '
          'hiérarchie visuelle, ergonomie, prototypage sur Figma.',
      category: 'Design',
      level: SkillLevel.intermediate,
      estimatedDuration: '3 semaines',
      wantedInExchange: 'Flutter',
      authorId: 'u1', // Sarah K.
      studentsCount: 87,
      associatedSkills: ['Figma', 'Design System'],
    ),
    const Skill(
      id: '5',
      title: 'Graphic Design',
      description:
          'Apprends à créer des visuels percutants : compositions, '
          'typographie, identité visuelle.',
      category: 'Design',
      level: SkillLevel.beginner,
      estimatedDuration: '2 semaines',
      wantedInExchange: 'Anglais',
      authorId: 'u5', // David P.
      studentsCount: 64,
      associatedSkills: ['Canva', 'Photoshop'],
    ),
    const Skill(
      id: '6',
      title: 'Marketing',
      description:
          'Bases du marketing digital : réseaux sociaux, stratégie de '
          'contenu, analyse d\'audience.',
      category: 'Business',
      level: SkillLevel.beginner,
      estimatedDuration: '2 semaines',
      wantedInExchange: 'Python',
      authorId: 'u4', // Emma R.
      studentsCount: 58,
      associatedSkills: ['Réseaux sociaux', 'SEO'],
    ),
    const Skill(
      id: '7',
      title: 'Anglais',
      description:
          'Progresse en anglais conversationnel et professionnel.',
      category: 'Langues',
      level: SkillLevel.beginner,
      estimatedDuration: '1 mois',
      wantedInExchange: 'React',
      authorId: 'u4', // Emma R.
      studentsCount: 340,
      associatedSkills: ['Conversation', 'Business English'],
    ),
  ];

  //Retourne toutes les catégories uniques (pour les filtres Explore).
  static List<String> get categories {
    return skills.map((skill) => skill.category).toSet().toList();
  }

  //Retrouve une compétence précise à partir de son id.
  static Skill? getById(String id) {
    try {
      return skills.firstWhere((skill) => skill.id == id);
    } catch (e) {
      return null;
    }
  }
}