import '../models/user.dart';

//Données de démonstration pour les utilisateurs de Swapfy.
//Ces mêmes profils sont réutilisés comme auteurs de compétences,
//comme matches, et comme contacts de messagerie.
class MockUsers {
  static const String currentUserId = 'u0';

  static final List<User> users = [
    const User(
      id: 'u0',
      name: 'Boris D.',
      avatarUrl: 'https://i.pravatar.cc/150?img=68',
      location: 'Lomé, Togo',
      bio: 'Étudiant en informatique passionné par le partage de '
          'connaissances. J\'aime apprendre autant qu\'enseigner.',
      skillsOffered: ['Flutter', 'Dart', 'Python', 'Firebase', 'Git'],
      skillsWanted: ['React', 'Node.js', 'UI/UX', 'DevOps'],
      exchangesCount: 12,
      rating: 4.9,
      isAvailable: true,
    ),
    const User(
      id: 'u1',
      name: 'Sarah K.',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      location: 'Lomé, Togo',
      bio: 'Designer UI/UX passionnée, toujours partante pour un '
          'échange de compétences.',
      skillsOffered: ['UI/UX Design', 'Figma'],
      skillsWanted: ['Flutter'],
      compatibilityPercent: 92,
      exchangesCount: 8,
      rating: 4.8,
      isOnline: true,
    ),
    const User(
      id: 'u2',
      name: 'Alex M.',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      location: 'Lomé, Togo',
      bio: 'Développeur mobile, j\'apprends le Python en ce moment.',
      skillsOffered: ['Python'],
      skillsWanted: ['Flutter'],
      compatibilityPercent: 88,
      exchangesCount: 5,
      rating: 4.6,
      isOnline: true,
    ),
    const User(
      id: 'u3',
      name: 'John D.',
      avatarUrl: 'https://i.pravatar.cc/150?img=14',
      location: 'Kara, Togo',
      bio: 'Développeur front-end React, curieux d\'apprendre le mobile.',
      skillsOffered: ['React'],
      skillsWanted: ['Flutter'],
      compatibilityPercent: 85,
      exchangesCount: 3,
      rating: 4.5,
      isOnline: false,
    ),
    const User(
      id: 'u4',
      name: 'Emma R.',
      avatarUrl: 'https://i.pravatar.cc/150?img=25',
      location: 'Lomé, Togo',
      bio: 'Bilingue anglais-français, j\'adore enseigner les langues.',
      skillsOffered: ['Anglais'],
      skillsWanted: ['React'],
      compatibilityPercent: 78,
      exchangesCount: 6,
      rating: 4.7,
      isOnline: false,
    ),
    const User(
      id: 'u5',
      name: 'David P.',
      avatarUrl: 'https://i.pravatar.cc/150?img=15',
      location: 'Lomé, Togo',
      bio: 'Passionné de data science et d\'automatisation.',
      skillsOffered: ['Python', 'Data Science'],
      skillsWanted: ['Design graphique'],
      compatibilityPercent: 60,
      exchangesCount: 2,
      rating: 4.3,
      isOnline: true,
    ),
  ];

  //Retourne l'utilisateur actuellement "connecté".
    static User get currentUser =>
        getById(currentUserId) ?? users.first;
  //Retrouve un utilisateur précis à partir de son id.
  static User? getById(String id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  //Retourne tous les utilisateurs SAUF l'utilisateur connecté,
  //triés du plus compatible au moins compatible. Utilisé pour
  //les écrans Matches et la section "Pour toi" de Home.
  static List<User> get matchesSortedByCompatibility {
    final others = users.where((user) => user.id != currentUserId).toList();
    others.sort((a, b) => b.compatibilityPercent.compareTo(a.compatibilityPercent));
    return others;
  }
}