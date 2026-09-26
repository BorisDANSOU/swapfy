import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:swapfy/l10n/app_localizations.dart';

void main() {
  test('localization exposes French and English locales', () {
    expect(
      AppLocalizations.supportedLocales,
      containsAll(const [Locale('fr'), Locale('en')]),
    );
  });

  test('main navigation labels are translated in French and English', () async {
    final french = await AppLocalizations.delegate.load(const Locale('fr'));
    final english = await AppLocalizations.delegate.load(const Locale('en'));

    expect(french.navHome, 'Accueil');
    expect(english.navHome, 'Home');
    expect(french.languageLabel, 'Langue');
    expect(english.languageLabel, 'Language');
  });
}
