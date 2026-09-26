// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Swapfy';

  @override
  String get loginTitle => 'Se connecter';

  @override
  String get registerTitle => 'Créer un compte';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get loginAction => 'Se connecter';

  @override
  String get registerAction => 'Créer un compte';

  @override
  String get invalidEmail => 'Entre un email valide';

  @override
  String get shortPassword =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get invalidCredentials => 'Identifiants invalides';

  @override
  String get loginFailed => 'Connexion impossible';

  @override
  String get registerFailed => 'Inscription impossible';

  @override
  String get navHome => 'Accueil';

  @override
  String get navExplore => 'Explorer';

  @override
  String get navMatches => 'Matches';

  @override
  String get navMessages => 'Messages';

  @override
  String get navProfile => 'Profil';

  @override
  String homeGreeting(String name) {
    return 'Bonjour $name';
  }

  @override
  String get homePrompt => 'Qu\'aimeriez-vous apprendre aujourd\'hui ?';

  @override
  String get searchSkill => 'Rechercher une compétence...';

  @override
  String get yourSkills => 'Vos compétences';

  @override
  String get viewAll => 'Voir tout';

  @override
  String get forYou => 'Pour vous';

  @override
  String get popularSkills => 'Compétences populaires';

  @override
  String get exploreTitle => 'Explorer les compétences';

  @override
  String get categoryAll => 'Toutes';

  @override
  String get noSkillsFound => 'Aucune compétence trouvée.';

  @override
  String get loadSkillsFailed => 'Impossible de charger les compétences.';

  @override
  String peopleCount(int count) {
    return '$count personnes';
  }

  @override
  String get matchesTitle => 'Vos meilleurs matchs';

  @override
  String get noMatches => 'Aucun match pour le moment.';

  @override
  String get loadMatchesFailed => 'Impossible de charger les matchs.';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get searchConversation => 'Rechercher une conversation...';

  @override
  String get noConversations => 'Aucune conversation trouvée.';

  @override
  String get loadConversationsFailed =>
      'Impossible de charger les conversations.';

  @override
  String get loadProfilesFailed => 'Impossible de charger les profils.';

  @override
  String get conversationTitle => 'Conversation';

  @override
  String get loadConversationFailed =>
      'Impossible de charger cette conversation.';

  @override
  String get loadMessagesFailed => 'Impossible de charger les messages.';

  @override
  String get writeMessage => 'Écrire un message...';

  @override
  String get sendMessage => 'Envoyer le message';

  @override
  String get profileTitle => 'Profil';

  @override
  String get editProfileAction => 'Modifier';

  @override
  String get exchanges => 'Échanges';

  @override
  String get skillsCount => 'Compétences';

  @override
  String get rating => 'Note';

  @override
  String get skillsOffered => 'Je maîtrise';

  @override
  String get skillsWanted => 'Je souhaite apprendre';

  @override
  String get about => 'À propos';

  @override
  String get available => 'Disponible pour échanger';

  @override
  String get unavailable => 'Indisponible';

  @override
  String get darkTheme => 'Thème sombre';

  @override
  String get enabled => 'Activé';

  @override
  String get disabled => 'Désactivé';

  @override
  String get languageLabel => 'Langue';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get editProfileTitle => 'Modifier mon profil';

  @override
  String get nameLabel => 'Nom *';

  @override
  String get bioLabel => 'Bio *';

  @override
  String get skillsOfferedLabel => 'Compétences maîtrisées *';

  @override
  String get skillsWantedLabel => 'Compétences recherchées *';

  @override
  String get skillsOfferedHint => 'Ex. : Flutter, Python';

  @override
  String get skillsWantedHint => 'Ex. : React, anglais';

  @override
  String get requiredName => 'Le nom est obligatoire';

  @override
  String get shortName => 'Le nom doit contenir au moins 2 caractères';

  @override
  String get requiredBio => 'La bio est obligatoire';

  @override
  String get shortBio => 'La bio doit contenir au moins 10 caractères';

  @override
  String get requiredOffered => 'Indiquez au moins une compétence maîtrisée';

  @override
  String get requiredWanted => 'Indiquez au moins une compétence recherchée';

  @override
  String get skillLevel => 'Niveau';

  @override
  String get beginner => 'Débutant';

  @override
  String get intermediate => 'Intermédiaire';

  @override
  String get expert => 'Expert';

  @override
  String get availability => 'Disponibilité';

  @override
  String get saveProfile => 'Enregistrer mon profil';

  @override
  String get savedProfile => 'Profil enregistré avec succès !';

  @override
  String get saveProfileFailed => 'Impossible d\'enregistrer le profil.';

  @override
  String get loadProfileFailed => 'Impossible de charger le profil.';

  @override
  String get profileMissing => 'Profil utilisateur introuvable.';

  @override
  String get skillNotFound => 'Cette compétence n\'existe pas.';

  @override
  String get averageLevel => 'Niveau moyen';

  @override
  String get description => 'Description';

  @override
  String get relatedSkills => 'Compétences associées';

  @override
  String peopleKnowSkill(String skill) {
    return 'Personnes qui maîtrisent $skill';
  }

  @override
  String get expertLevel => 'Niveau expert';

  @override
  String get intermediateLevel => 'Niveau intermédiaire';

  @override
  String get exchangeProposal => 'Proposer un échange';

  @override
  String photoOf(String name) {
    return 'Photo de $name';
  }

  @override
  String messageFromYou(String message) {
    return 'Vous : $message';
  }

  @override
  String messageFromPartner(String name, String message) {
    return '$name : $message';
  }

  @override
  String get exchangeAction => 'Échanger';

  @override
  String get viewAction => 'Voir';
}
