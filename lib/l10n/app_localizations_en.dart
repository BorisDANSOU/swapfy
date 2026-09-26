// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Swapfy';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get registerTitle => 'Create an account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get loginAction => 'Sign in';

  @override
  String get registerAction => 'Create an account';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get shortPassword => 'Password must contain at least 6 characters';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String get loginFailed => 'Unable to sign in';

  @override
  String get registerFailed => 'Unable to create the account';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navMatches => 'Matches';

  @override
  String get navMessages => 'Messages';

  @override
  String get navProfile => 'Profile';

  @override
  String homeGreeting(String name) {
    return 'Hello $name';
  }

  @override
  String get homePrompt => 'What would you like to learn today?';

  @override
  String get searchSkill => 'Search for a skill...';

  @override
  String get yourSkills => 'Your skills';

  @override
  String get viewAll => 'View all';

  @override
  String get forYou => 'For you';

  @override
  String get popularSkills => 'Popular skills';

  @override
  String get exploreTitle => 'Explore skills';

  @override
  String get categoryAll => 'All';

  @override
  String get noSkillsFound => 'No skills found.';

  @override
  String get loadSkillsFailed => 'Unable to load skills.';

  @override
  String peopleCount(int count) {
    return '$count people';
  }

  @override
  String get matchesTitle => 'Your top matches';

  @override
  String get noMatches => 'No matches yet.';

  @override
  String get loadMatchesFailed => 'Unable to load matches.';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get searchConversation => 'Search conversations...';

  @override
  String get noConversations => 'No conversations found.';

  @override
  String get loadConversationsFailed => 'Unable to load conversations.';

  @override
  String get loadProfilesFailed => 'Unable to load profiles.';

  @override
  String get conversationTitle => 'Conversation';

  @override
  String get loadConversationFailed => 'Unable to load this conversation.';

  @override
  String get loadMessagesFailed => 'Unable to load messages.';

  @override
  String get writeMessage => 'Write a message...';

  @override
  String get sendMessage => 'Send message';

  @override
  String get profileTitle => 'Profile';

  @override
  String get editProfileAction => 'Edit';

  @override
  String get exchanges => 'Exchanges';

  @override
  String get skillsCount => 'Skills';

  @override
  String get rating => 'Rating';

  @override
  String get skillsOffered => 'I can teach';

  @override
  String get skillsWanted => 'I want to learn';

  @override
  String get about => 'About';

  @override
  String get available => 'Available to exchange';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get enabled => 'On';

  @override
  String get disabled => 'Off';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageFrench => 'French';

  @override
  String get languageEnglish => 'English';

  @override
  String get editProfileTitle => 'Edit my profile';

  @override
  String get nameLabel => 'Name *';

  @override
  String get bioLabel => 'Bio *';

  @override
  String get skillsOfferedLabel => 'Skills I can teach *';

  @override
  String get skillsWantedLabel => 'Skills I want to learn *';

  @override
  String get skillsOfferedHint => 'E.g. Flutter, Python';

  @override
  String get skillsWantedHint => 'E.g. React, English';

  @override
  String get requiredName => 'Name is required';

  @override
  String get shortName => 'Name must contain at least 2 characters';

  @override
  String get requiredBio => 'Bio is required';

  @override
  String get shortBio => 'Bio must contain at least 10 characters';

  @override
  String get requiredOffered => 'Add at least one skill you can teach';

  @override
  String get requiredWanted => 'Add at least one skill you want to learn';

  @override
  String get skillLevel => 'Level';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get expert => 'Expert';

  @override
  String get availability => 'Availability';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get savedProfile => 'Profile saved successfully!';

  @override
  String get saveProfileFailed => 'Unable to save the profile.';

  @override
  String get loadProfileFailed => 'Unable to load the profile.';

  @override
  String get profileMissing => 'User profile not found.';

  @override
  String get skillNotFound => 'This skill does not exist.';

  @override
  String get averageLevel => 'Average level';

  @override
  String get description => 'Description';

  @override
  String get relatedSkills => 'Related skills';

  @override
  String peopleKnowSkill(String skill) {
    return 'People who know $skill';
  }

  @override
  String get expertLevel => 'Expert level';

  @override
  String get intermediateLevel => 'Intermediate level';

  @override
  String get exchangeProposal => 'Offer an exchange';

  @override
  String photoOf(String name) {
    return 'Photo of $name';
  }

  @override
  String messageFromYou(String message) {
    return 'You: $message';
  }

  @override
  String messageFromPartner(String name, String message) {
    return '$name: $message';
  }

  @override
  String get exchangeAction => 'Exchange';

  @override
  String get viewAction => 'View';
}
