import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales basados en la Identidad Visual de Antigravity Soriana
  static const Color primaryYellow = Color(0xFFF7C02F);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color softOrange = Color(0xFFFFB74D);

  // Bordes redondeados estandarizados
  static const double borderRadius = 30.0;

  // Tema global de la aplicación
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryYellow,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryYellow,
        secondary: primaryGreen,
        tertiary: softOrange,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: primaryYellow,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
