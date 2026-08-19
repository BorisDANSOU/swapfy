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
}