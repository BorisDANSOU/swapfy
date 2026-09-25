import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Centralise tout le thème de l'application : couleurs, polices,
//dégradé de marque, et styles des composants (boutons, champs, cartes)
//pour le mode clair ET le mode sombre.
class AppTheme {
  //--- Couleurs de marque (logo Swapfy : violet vers bleu cyan) ---
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color primaryBlue = Color(0xFF00B4D8);

  //Dégradé principal, utilisé sur le logo, les boutons d'action
  //principaux, et les éléments de mise en avant (ex: badge "FY").
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color secondary = Color(0xFF00B4D8);
  static const Color error = Color(0xFFE63946);
  static const Color success = Color(0xFF2ECC71);

  //Couleurs de fond en mode clair.
  static const Color backgroundLight = Color(0xFFF7F8FC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF1A1B25);

  //Couleurs de fond en mode sombre (bleu nuit très profond,
  //comme vu sur le fond du moodboard).
  static const Color backgroundDark = Color(0xFF0D0E21);
  static const Color surfaceDark = Color(0xFF1A1C35);
  static const Color onSurfaceDark = Color(0xFFEDEDF7);

  //--- Thème clair ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.light,
        primary: primaryPurple,
        secondary: secondary,
        error: error,
        surface: surfaceLight,
      ),
      //Hanken Grotesk pour les titres (identité visuelle forte),
      //Inter pour le texte courant (lisibilité).
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: GoogleFonts.hankenGrotesk(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: onSurfaceLight,
        ),
        titleMedium: GoogleFonts.hankenGrotesk(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: onSurfaceLight,
        ),
        bodyLarge: GoogleFonts.inter(fontSize: 15, color: onSurfaceLight),
        bodyMedium: GoogleFonts.inter(fontSize: 13, color: onSurfaceLight),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: onSurfaceLight.withValues(alpha: 0.6),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE4E4F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceLight,
        indicatorColor: primaryPurple.withValues(alpha: 0.15),
      ),
    );
  }

  //--- Thème sombre ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.dark,
        primary: const Color(0xFFA9A0FF),
        secondary: const Color(0xFF4DD8F0),
        error: const Color(0xFFFF8A80),
        surface: surfaceDark,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            headlineLarge: GoogleFonts.hankenGrotesk(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: onSurfaceDark,
            ),
            titleMedium: GoogleFonts.hankenGrotesk(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: onSurfaceDark,
            ),
            bodyLarge: GoogleFonts.inter(fontSize: 15, color: onSurfaceDark),
            bodyMedium: GoogleFonts.inter(fontSize: 13, color: onSurfaceDark),
            labelSmall: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: onSurfaceDark.withValues(alpha: 0.6),
            ),
          ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF4DD8F0), width: 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceDark,
        indicatorColor: const Color(0xFFA9A0FF).withValues(alpha: 0.2),
      ),
    );
  }
}
