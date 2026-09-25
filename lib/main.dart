import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'l10n/app_localizations.dart';
import 'app/theme.dart';
import 'app/router.dart';
import 'app/theme_controller.dart';
import 'app/locale_controller.dart';
import 'app/firebase_bootstrap.dart';
import 'repositories/firebase/firebase_auth_repository.dart';
import 'repositories/firebase/firebase_messages_repository.dart';

//Point d'entrée de l'application : la fonction main() est le tout
//premier code exécuté au lancement de l'app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();

  runApp(
    SwapfyApp(
      routerConfig: AppRouter(
        instanceAuthRepository: FirebaseAuthRepository(),
        instanceMessagesRepository: FirebaseMessagesRepository(),
      ).goRouter,
    ),
  );
}

//Widget racine de l'application. StatefulWidget car il doit ÉCOUTER
//le ThemeController et se redessiner automatiquement dès que le
//thème clair/sombre change.
class SwapfyApp extends StatefulWidget {
  final GoRouter routerConfig;

  const SwapfyApp({super.key, required this.routerConfig});

  @override
  State<SwapfyApp> createState() => _SwapfyAppState();
}

class _SwapfyAppState extends State<SwapfyApp> {
  final LocaleController _localeController = LocaleController();
  @override
  void initState() {
    super.initState();
    //On s'abonne au ThemeController : chaque fois qu'il appelle
    //notifyListeners() (via setDarkMode dans ProfileScreen),
    //_onThemeChanged sera appelée automatiquement.
    ThemeController.instance.addListener(_onThemeChanged);
    _localeController.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    //Toujours se désabonner en quittant, pour éviter les fuites mémoire.
    ThemeController.instance.removeListener(_onThemeChanged);
    _localeController.removeListener(_onLocaleChanged);
    _localeController.dispose();
    super.dispose();
  }

  //Appelée automatiquement à chaque changement de thème : on force
  //ce widget à se redessiner, ce qui relit isDarkMode dans build().
  void _onThemeChanged() {
    setState(() {});
  }

  void _onLocaleChanged() {
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
      locale: _localeController.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      //MaterialApp.router (plutôt que MaterialApp classique) est la
      //version compatible avec GoRouter.
      routerConfig: widget.routerConfig,
    );
  }
}
