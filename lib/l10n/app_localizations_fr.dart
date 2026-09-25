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
}
