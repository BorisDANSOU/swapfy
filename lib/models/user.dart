//Modèle représentant un utilisateur de Swapfy. Sert à la fois pour
//le profil de l'utilisateur connecté, et pour les profils des autres
//personnes (matches, auteurs de compétences, contacts de messagerie).
class User {
  final String id;
  final String name;
  final String avatarUrl;
  final String location;
  final String bio;
  final List<String> skillsOffered;
  final List<String> skillsWanted;
  final int compatibilityPercent;
  final int exchangesCount;
  final double rating;
  final bool isOnline;
  final bool isAvailable;

  const User({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.location,
    required this.bio,
    required this.skillsOffered,
    required this.skillsWanted,
    this.compatibilityPercent = 0,
    this.exchangesCount = 0,
    this.rating = 0.0,
    this.isOnline = false,
    this.isAvailable = true,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      avatarUrl: map['avatarUrl'] as String? ?? '',
      location: map['location'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      skillsOffered: List<String>.from(
        map['skillsOffered'] as List<dynamic>? ?? const [],
      ),
      skillsWanted: List<String>.from(
        map['skillsWanted'] as List<dynamic>? ?? const [],
      ),
      compatibilityPercent: map['compatibilityPercent'] as int? ?? 0,
      exchangesCount: map['exchangesCount'] as int? ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      isOnline: map['isOnline'] as bool? ?? false,
      isAvailable: map['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'location': location,
      'bio': bio,
      'skillsOffered': skillsOffered,
      'skillsWanted': skillsWanted,
      'compatibilityPercent': compatibilityPercent,
      'exchangesCount': exchangesCount,
      'rating': rating,
      'isOnline': isOnline,
      'isAvailable': isAvailable,
    };
  }
}
