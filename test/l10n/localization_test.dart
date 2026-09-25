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
}
