import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Apple Fitness Inspired Neon Colors
  static const Color darkBackground = Color(0xFF000000);
  static const Color cardBackground = Color(0xFF1C1C1E);
  static const Color cardSecondary = Color(0xFF2C2C2E);
  static const Color cardTertiary = Color(0xFF3A3A3C);

  static const Color redPulse = Color(0xFFFF2442);     // Calories / Workouts
  static const Color greenNeon = Color(0xFFA6FF00);    // Timer / Active Time
  static const Color blueCyan = Color(0xFF00E5FF);     // Water / Hydration / Stand
  static const Color orangeGlow = Color(0xFFFF9500);   // Nutrition / Protein
  static const Color purpleNeon = Color(0xFFBF5AF2);   // Measurements / Body

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textMuted = Color(0xFF636366);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: redPulse,
      colorScheme: const ColorScheme.dark(
        primary: redPulse,
        secondary: greenNeon,
        surface: cardBackground,
        background: darkBackground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xDD121214),
        selectedItemColor: redPulse,
        unselectedItemColor: textSecondary,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF26262A), width: 1),
        ),
      ),
      fontFamily: '.SF Pro Text',
    );
  }
}
