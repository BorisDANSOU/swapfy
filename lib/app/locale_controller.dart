import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  Locale _locale = const Locale('fr');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (locale == _locale) return;
    _locale = locale;
    notifyListeners();
  }
}
