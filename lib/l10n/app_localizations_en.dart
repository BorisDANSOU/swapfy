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
}
