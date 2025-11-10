// Fichero: lib/config/app_theme.dart
import 'package:flutter/material.dart';

/// Clase que define la paleta de colores corporativa de ADV Formación.
class AppColors {
  // Paleta de colores Hex:
  // morado academia: 3C235E
  // morado noche: 2A1645
  // morado medio: 6A26E9
  // morado luz: 6C63FF
  // blanco puro: FFFFFF

  static const Color primary = Color(0xFF3C235E); // Morado Academia
  static const Color primaryDark = Color(0xFF2A1645); // Morado Noche
  static const Color accent = Color(0xFF6A26E9); // Morado Medio
  static const Color highlight = Color(0xFF6C63FF); // Morado Luz
  static const Color white = Color(0xFFFFFFFF); // Blanco Puro
  static const Color error = Colors.redAccent;
  static const Color success = Color(0xFF6C63FF);

  static get moradoLuz => null; // Usamos morado luz para éxito (aprobado)
}

/// Tema de la aplicación utilizando Material Design 3.
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        surface: AppColors.white,
        background: AppColors.white,
        error: AppColors.error,
        onBackground: AppColors.primaryDark,
        onSurface: AppColors.primaryDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Estilo para botones redondeados y con sombra suave
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          elevation: 5,
          shadowColor: AppColors.accent.withOpacity(0.5),
        ),
      ),
      // Estilo para tarjetas
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 4,
        shadowColor: AppColors.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      // Estilo de texto general
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
        bodyMedium: TextStyle(color: AppColors.primaryDark),
        bodySmall: TextStyle(color: Colors.grey),
      ),
    );
  }
}
