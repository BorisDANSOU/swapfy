import 'package:flutter/material.dart';
import 'app/theme.dart';
import 'app/router.dart';
import 'app/theme_controller.dart';

//Point d'entrée de l'application : la fonction main() est le tout
//premier code exécuté au lancement de l'app.
void main() {
  runApp(const SwapfyApp());
}

//Widget racine de l'application. StatefulWidget car il doit ÉCOUTER
//le ThemeController et se redessiner automatiquement dès que le
//thème clair/sombre change.
class SwapfyApp extends StatefulWidget {
  const SwapfyApp({super.key});

  @override
  State<SwapfyApp> createState() => _SwapfyAppState();
}

class _SwapfyAppState extends State<SwapfyApp> {
  @override
  void initState() {
    super.initState();
    //On s'abonne au ThemeController : chaque fois qu'il appelle
    //notifyListeners() (via setDarkMode dans ProfileScreen),
    //_onThemeChanged sera appelée automatiquement.
    ThemeController.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    //Toujours se désabonner en quittant, pour éviter les fuites mémoire.
    ThemeController.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  //Appelée automatiquement à chaque changement de thème : on force
  //ce widget à se redessiner, ce qui relit isDarkMode dans build().
  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Swapfy',
      debugShowCheckedModeBanner: false,

      //Les deux thèmes complets sont toujours fournis...
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      //...et themeMode décide LEQUEL est actif, en lisant l'état
      //actuel du ThemeController.
      themeMode: ThemeController.instance.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

      //MaterialApp.router (plutôt que MaterialApp classique) est la
      //version compatible avec GoRouter.
      routerConfig: AppRouter.router,
    );
  }
}