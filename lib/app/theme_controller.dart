import 'package:flutter/foundation.dart';

//Contrôleur qui garde en mémoire si le thème sombre est actif, et
//prévient automatiquement toute l'app quand cette valeur change.
//ChangeNotifier permet à n'importe quel widget "à l'écoute" de se
//redessiner automatiquement dès que notifyListeners() est appelé.
class ThemeController extends ChangeNotifier {
  //Instance unique partagée dans toute l'app (singleton) : ainsi,
  //main.dart ET n'importe quel écran peuvent y accéder directement
  //via ThemeController.instance, sans avoir à se le transmettre
  //manuellement de widget en widget.
  static final ThemeController instance = ThemeController._internal();
  ThemeController._internal();

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  //Change l'état et prévient tous les widgets à l'écoute (main.dart)
  //qu'ils doivent se redessiner avec le nouveau thème.
  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}