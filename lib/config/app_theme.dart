// Fichero: lib/config/app_theme.dart
import 'package:flutter/material.dart';

class AppColors {
  // -----------------------------------------------------------
  // Colores base
  // -----------------------------------------------------------
  static const Color primary = Color(0xFFB34851); // rojo principal
  static const Color primaryDark = Color(0xFF8E2E37);
  static const Color primaryLight = Color(0xFFD98289);

  // Dorado
  static const Color gold = Color(0xFFEFB810);
  static const Color goldDark = Color(0xFFC99A0E);
  static const Color goldLight = Color(0xFFFFD75A);

  // Platino
  static const Color platinum = Color(0xFFE3E4E5);
  static const Color platinumDark = Color(0xFFB9BBBD);
  static const Color platinumLight = Color(0xFFF8F9FA);

  // Compatibilidad con código antiguo
  static const Color accent = gold;
  static const Color accentDark = goldDark;
  static const Color accentLight = goldLight;
  static const Color highlight = goldLight; // ✅ corregido

  static const Color white = Colors.white;
  static const Color error = Colors.redAccent;
  static const Color success = Color(0xFF4CAF50);

  // -----------------------------------------------------------
  // Gradientes metalizados
  // -----------------------------------------------------------
  static const LinearGradient goldRedGradient = LinearGradient(
    colors: [
      Color(0xFFEFB810),
      Color(0xFFEFA810),
      Color(0xFFB34851),
      Color(0xFFEFB810),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient platinumGradient = LinearGradient(
    colors: [
      Color(0xFFE3E4E5),
      Color(0xFFF8F9FA),
      Color(0xFFE3E4E5),
      Color(0xFFB9BBBD),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  // ===========================================================
  // TEMA CLARO METALIZADO
  // ===========================================================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,

      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.gold,
        background: AppColors.white,
        surface: AppColors.white,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryDark,
        elevation: 4,
        shadowColor: AppColors.primaryDark.withOpacity(0.5),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Botones metalizados dorado → rojo
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 28, vertical: 14)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          elevation: MaterialStateProperty.all(8),
          shadowColor: MaterialStateProperty.all(AppColors.primaryDark.withOpacity(0.6)),
          backgroundColor: MaterialStateProperty.all(AppColors.gold), // para compatibilidad
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 10,
        shadowColor: AppColors.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: AppColors.white,
      ),

      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: AppColors.primaryDark,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          color: AppColors.primaryDark,
          fontSize: 16,
        ),
      ),
    );
  }

  // ===========================================================
  // TEMA OSCURO METALIZADO
  // ===========================================================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),

      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryLight,
        secondary: AppColors.goldLight,
        surface: const Color(0xFF1A1A1A),
        background: const Color(0xFF121212),
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 12,
        shadowColor: AppColors.primaryLight.withOpacity(0.35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
