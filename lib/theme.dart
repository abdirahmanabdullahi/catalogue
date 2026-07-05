import 'package:flutter/material.dart';

/// Qiantao brand palette — emerald accent on a cool slate ink, premium and
/// calm. Token names are kept generic; the values define the brand.
abstract class GfColors {
  static const actionBlue = Color(0xFF0EA371); // emerald — primary action
  static const actionBlueHover = Color(0xFF0B8A5F);
  static const darkBlue = Color(0xFF0B6E4F); // deep emerald (headings, heroes)
  static const deepBlue = Color(0xFF08553C); // darker emerald
  static const lightBlue = Color(0xFF7DE0B8); // light emerald (on dark)
  static const ink = Color(0xFF0C1F17); // primary text — dark green-charcoal
  static const red = Color(0xFFE5484D); // error / destructive
  static const grey100 = Color(0xFFF1F5F4); // subtle section background
  static const grey200 = Color(0xFFE6ECEA);
  static const grey300 = Color(0xFFD6DEDB); // borders
  static const grey400 = Color(0xFFB8C2BF);
  static const grey500 = Color(0xFF97A29E);
  static const grey600 = Color(0xFF6B7671); // secondary text
  static const grey700 = Color(0xFF53605B);
  static const grey800 = Color(0xFF37423D);
  static const white = Color(0xFFFFFFFF);

  // Chart / accent palette (validated for the emerald light UI).
  static const curveBlue = Color(0xFF0B6E4F); // dark green (max speed)
  static const curveMid = Color(0xFF0EA371); // emerald (mid)
  static const curveLight = Color(0xFF34C48A); // light green (min)
  static const teal = Color(0xFF0FB5AE);
  static const amber = Color(0xFFF5A623);
  static const green = Color(0xFF0EA371);
}

/// Brand gradients used across heroes and feature surfaces.
abstract class GfGradients {
  static const hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0EA371), Color(0xFF08553C)],
  );
  static const deep = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [GfColors.darkBlue, Color(0xFF05261B)],
  );
  static const ai = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0EA371), Color(0xFF0FB5AE)],
  );
  static const accent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0EA371), Color(0xFF0B8A5F)],
  );
}

/// Soft elevation shadow for cards and floating surfaces.
const List<BoxShadow> gfCardShadow = [
  BoxShadow(
    color: Color(0x12101828),
    blurRadius: 28,
    offset: Offset(0, 10),
  ),
];

ThemeData qiantaoTheme() {
  const base = 'Qiantao';
  return ThemeData(
    useMaterial3: true,
    fontFamily: base,
    scaffoldBackgroundColor: GfColors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: GfColors.actionBlue,
      primary: GfColors.actionBlue,
      secondary: GfColors.deepBlue,
      error: GfColors.red,
      surface: GfColors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: GfColors.white,
      foregroundColor: GfColors.ink,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(
          fontFamily: 'Qiantao-Extd',
          fontWeight: FontWeight.w700,
          color: GfColors.ink,
          height: 1.15),
      headlineMedium: TextStyle(
          fontFamily: 'Qiantao-Extd',
          fontWeight: FontWeight.w700,
          color: GfColors.ink,
          height: 1.2),
      headlineSmall: TextStyle(
          fontFamily: 'Qiantao-Extd',
          fontWeight: FontWeight.w700,
          color: GfColors.ink,
          height: 1.25),
      titleLarge: TextStyle(
          fontWeight: FontWeight.w700, color: GfColors.ink, height: 1.3),
      titleMedium: TextStyle(
          fontWeight: FontWeight.w700, color: GfColors.ink, height: 1.3),
      bodyLarge:
          TextStyle(color: GfColors.ink, height: 1.5, fontWeight: FontWeight.w400),
      bodyMedium:
          TextStyle(color: GfColors.ink, height: 1.5, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(color: GfColors.grey700, height: 1.4),
    ),
    // Premium rounded-rectangle buttons (not full pills).
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: GfColors.actionBlue,
        foregroundColor: GfColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
            fontFamily: base, fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: GfColors.actionBlue,
        side: const BorderSide(color: GfColors.actionBlue, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
            fontFamily: base, fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: GfColors.actionBlue,
        textStyle: const TextStyle(
            fontFamily: base, fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: GfColors.grey100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GfColors.grey300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GfColors.grey300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: GfColors.actionBlue, width: 2),
      ),
      hintStyle: const TextStyle(color: GfColors.grey600),
    ),
    dividerTheme: const DividerThemeData(color: GfColors.grey200, thickness: 1),
    chipTheme: const ChipThemeData(
      backgroundColor: GfColors.grey100,
      side: BorderSide(color: GfColors.grey200),
      labelStyle: TextStyle(color: GfColors.ink),
    ),
  );
}
