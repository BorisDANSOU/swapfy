import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Swapfy'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get registerTitle;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @loginAction.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginAction;

  /// No description provided for @registerAction.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get registerAction;

  /// No description provided for @invalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Entre un email valide'**
  String get invalidEmail;

  /// No description provided for @shortPassword.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 6 caractères'**
  String get shortPassword;

  /// No description provided for @invalidCredentials.
  ///
  /// In fr, this message translates to:
  /// **'Identifiants invalides'**
  String get invalidCredentials;

  /// No description provided for @loginFailed.
  ///
  /// In fr, this message translates to:
  /// **'Connexion impossible'**
  String get loginFailed;

  /// No description provided for @registerFailed.
  ///
  /// In fr, this message translates to:
  /// **'Inscription impossible'**
  String get registerFailed;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In fr, this message translates to:
  /// **'Explorer'**
  String get navExplore;

  /// No description provided for @navMatches.
  ///
  /// In fr, this message translates to:
  /// **'Matches'**
  String get navMatches;

  /// No description provided for @navMessages.
  ///
  /// In fr, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @homeGreeting.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {name}'**
  String homeGreeting(String name);

  /// No description provided for @homePrompt.
  ///
  /// In fr, this message translates to:
  /// **'Qu\'aimeriez-vous apprendre aujourd\'hui ?'**
  String get homePrompt;

  /// No description provided for @searchSkill.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une compétence...'**
  String get searchSkill;

  /// No description provided for @yourSkills.
  ///
  /// In fr, this message translates to:
  /// **'Vos compétences'**
  String get yourSkills;

  /// No description provided for @viewAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get viewAll;

  /// No description provided for @forYou.
  ///
  /// In fr, this message translates to:
  /// **'Pour vous'**
  String get forYou;

  /// No description provided for @popularSkills.
  ///
  /// In fr, this message translates to:
  /// **'Compétences populaires'**
  String get popularSkills;

  /// No description provided for @exploreTitle.
  ///
  /// In fr, this message translates to:
  /// **'Explorer les compétences'**
  String get exploreTitle;

  /// No description provided for @categoryAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get categoryAll;

  /// No description provided for @noSkillsFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucune compétence trouvée.'**
  String get noSkillsFound;

  /// No description provided for @loadSkillsFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les compétences.'**
  String get loadSkillsFailed;

  /// No description provided for @peopleCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} personnes'**
  String peopleCount(int count);

  /// No description provided for @matchesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos meilleurs matchs'**
  String get matchesTitle;

  /// No description provided for @noMatches.
  ///
  /// In fr, this message translates to:
  /// **'Aucun match pour le moment.'**
  String get noMatches;

  /// No description provided for @loadMatchesFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les matchs.'**
  String get loadMatchesFailed;

  /// No description provided for @messagesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @searchConversation.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une conversation...'**
  String get searchConversation;

  /// No description provided for @noConversations.
  ///
  /// In fr, this message translates to:
  /// **'Aucune conversation trouvée.'**
  String get noConversations;

  /// No description provided for @loadConversationsFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les conversations.'**
  String get loadConversationsFailed;

  /// No description provided for @loadProfilesFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les profils.'**
  String get loadProfilesFailed;

  /// No description provided for @conversationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Conversation'**
  String get conversationTitle;

  /// No description provided for @loadConversationFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger cette conversation.'**
  String get loadConversationFailed;

  /// No description provided for @loadMessagesFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les messages.'**
  String get loadMessagesFailed;

  /// No description provided for @writeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Écrire un message...'**
  String get writeMessage;

  /// No description provided for @sendMessage.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le message'**
  String get sendMessage;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @editProfileAction.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get editProfileAction;

  /// No description provided for @exchanges.
  ///
  /// In fr, this message translates to:
  /// **'Échanges'**
  String get exchanges;

  /// No description provided for @skillsCount.
  ///
  /// In fr, this message translates to:
  /// **'Compétences'**
  String get skillsCount;

  /// No description provided for @rating.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get rating;

  /// No description provided for @skillsOffered.
  ///
  /// In fr, this message translates to:
  /// **'Je maîtrise'**
  String get skillsOffered;

  /// No description provided for @skillsWanted.
  ///
  /// In fr, this message translates to:
  /// **'Je souhaite apprendre'**
  String get skillsWanted;

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about;

  /// No description provided for @available.
  ///
  /// In fr, this message translates to:
  /// **'Disponible pour échanger'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In fr, this message translates to:
  /// **'Indisponible'**
  String get unavailable;

  /// No description provided for @darkTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème sombre'**
  String get darkTheme;

  /// No description provided for @enabled.
  ///
  /// In fr, this message translates to:
  /// **'Activé'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In fr, this message translates to:
  /// **'Désactivé'**
  String get disabled;

  /// No description provided for @languageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get languageLabel;

  /// No description provided for @languageFrench.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageEnglish.
  ///
  /// In fr, this message translates to:
  /// **'Anglais'**
  String get languageEnglish;

  /// No description provided for @editProfileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier mon profil'**
  String get editProfileTitle;

  /// No description provided for @nameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom *'**
  String get nameLabel;

  /// No description provided for @bioLabel.
  ///
  /// In fr, this message translates to:
  /// **'Bio *'**
  String get bioLabel;

  /// No description provided for @skillsOfferedLabel.
  ///
  /// In fr, this message translates to:
  /// **'Compétences maîtrisées *'**
  String get skillsOfferedLabel;

  /// No description provided for @skillsWantedLabel.
  ///
  /// In fr, this message translates to:
  /// **'Compétences recherchées *'**
  String get skillsWantedLabel;

  /// No description provided for @skillsOfferedHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. : Flutter, Python'**
  String get skillsOfferedHint;

  /// No description provided for @skillsWantedHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. : React, anglais'**
  String get skillsWantedHint;

  /// No description provided for @requiredName.
  ///
  /// In fr, this message translates to:
  /// **'Le nom est obligatoire'**
  String get requiredName;

  /// No description provided for @shortName.
  ///
  /// In fr, this message translates to:
  /// **'Le nom doit contenir au moins 2 caractères'**
  String get shortName;

  /// No description provided for @requiredBio.
  ///
  /// In fr, this message translates to:
  /// **'La bio est obligatoire'**
  String get requiredBio;

  /// No description provided for @shortBio.
  ///
  /// In fr, this message translates to:
  /// **'La bio doit contenir au moins 10 caractères'**
  String get shortBio;

  /// No description provided for @requiredOffered.
  ///
  /// In fr, this message translates to:
  /// **'Indiquez au moins une compétence maîtrisée'**
  String get requiredOffered;

  /// No description provided for @requiredWanted.
  ///
  /// In fr, this message translates to:
  /// **'Indiquez au moins une compétence recherchée'**
  String get requiredWanted;

  /// No description provided for @skillLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau'**
  String get skillLevel;

  /// No description provided for @beginner.
  ///
  /// In fr, this message translates to:
  /// **'Débutant'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In fr, this message translates to:
  /// **'Intermédiaire'**
  String get intermediate;

  /// No description provided for @expert.
  ///
  /// In fr, this message translates to:
  /// **'Expert'**
  String get expert;

  /// No description provided for @availability.
  ///
  /// In fr, this message translates to:
  /// **'Disponibilité'**
  String get availability;

  /// No description provided for @saveProfile.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer mon profil'**
  String get saveProfile;

  /// No description provided for @savedProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil enregistré avec succès !'**
  String get savedProfile;

  /// No description provided for @saveProfileFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'enregistrer le profil.'**
  String get saveProfileFailed;

  /// No description provided for @loadProfileFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger le profil.'**
  String get loadProfileFailed;

  /// No description provided for @profileMissing.
  ///
  /// In fr, this message translates to:
  /// **'Profil utilisateur introuvable.'**
  String get profileMissing;

  /// No description provided for @skillNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Cette compétence n\'existe pas.'**
  String get skillNotFound;

  /// No description provided for @averageLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau moyen'**
  String get averageLevel;

  /// No description provided for @description.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @relatedSkills.
  ///
  /// In fr, this message translates to:
  /// **'Compétences associées'**
  String get relatedSkills;

  /// No description provided for @peopleKnowSkill.
  ///
  /// In fr, this message translates to:
  /// **'Personnes qui maîtrisent {skill}'**
  String peopleKnowSkill(String skill);

  /// No description provided for @expertLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau expert'**
  String get expertLevel;

  /// No description provided for @intermediateLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau intermédiaire'**
  String get intermediateLevel;

  /// No description provided for @exchangeProposal.
  ///
  /// In fr, this message translates to:
  /// **'Proposer un échange'**
  String get exchangeProposal;

  /// No description provided for @photoOf.
  ///
  /// In fr, this message translates to:
  /// **'Photo de {name}'**
  String photoOf(String name);

  /// No description provided for @messageFromYou.
  ///
  /// In fr, this message translates to:
  /// **'Vous : {message}'**
  String messageFromYou(String message);

  /// No description provided for @messageFromPartner.
  ///
  /// In fr, this message translates to:
  /// **'{name} : {message}'**
  String messageFromPartner(String name, String message);

  /// No description provided for @exchangeAction.
  ///
  /// In fr, this message translates to:
  /// **'Échanger'**
  String get exchangeAction;

  /// No description provided for @viewAction.
  ///
  /// In fr, this message translates to:
  /// **'Voir'**
  String get viewAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
