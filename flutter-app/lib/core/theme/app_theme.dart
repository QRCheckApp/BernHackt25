import 'package:flutter/material.dart';

class AppTheme {
  // Custom Color Scheme for Hütte App
  static const ColorScheme huettliListaScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary
    primary: Color(0xFF2F855A),        // Tannengrün
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFA7F3D0), // Pastellgrün
    onPrimaryContainer: Color(0xFF1C4532),

    // Secondary
    secondary: Color(0xFFA7F3D0), // Pastellgrün
    onSecondary: Colors.black,
    secondaryContainer: Color.fromARGB(255, 193, 241, 219), // Pastellgrün
    onSecondaryContainer: Color.fromARGB(255, 7, 69, 74),

    // Tertiary
    tertiary: Color(0xFFE53E3E),        // Beerenrot
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFFB4AB),
    onTertiaryContainer: Color(0xFF690005),

    // Error
    error: Color(0xFFB3261E),
    onError: Colors.white,
    errorContainer: Color(0xFFFCDCD7),
    onErrorContainer: Color(0xFF410002),

    // Background & Surface
    background: Color.fromARGB(255, 255, 251, 241),      // Helles Beige (Holz/Hütte)
    onBackground: Color(0xFF2D3748),    // Anthrazit
    surface: Color.fromARGB(255, 255, 251, 241),
    onSurface: Color(0xFF2D3748),

    // Outline / Divider
    outline: Color(0xFFCBD5E0),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: huettliListaScheme,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );
}
