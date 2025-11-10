import 'package:flutter/material.dart';

class AppColors {
  static const Color moradoAcademia = Color(0xFF3C235E);
  static const Color moradoNoche = Color(0xFF2D1645);
  static const Color moradoMedio = Color(0xFF6E2679);
  static const Color moradoLuz = Color(0xFFB063F7);
  static const Color blanco = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.moradoAcademia,
    scaffoldBackgroundColor: AppColors.blanco,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.light(
      primary: AppColors.moradoAcademia,
      secondary: AppColors.moradoMedio,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.moradoLuz,
    scaffoldBackgroundColor: AppColors.moradoNoche,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.dark(
      primary: AppColors.moradoLuz,
      secondary: AppColors.moradoMedio,
    ),
  );
}