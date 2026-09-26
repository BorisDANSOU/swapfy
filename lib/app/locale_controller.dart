import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  static final LocaleController instance = LocaleController._();

  LocaleController._();

  Locale _locale = const Locale('fr');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (locale == _locale) return;
    _locale = locale;
    notifyListeners();
  }
}
