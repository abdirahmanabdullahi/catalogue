import 'package:flutter/material.dart';

/// Grundfos brand palette, extracted from the site's base CSS
/// (product-selection.grundfos.com, aembase base-css).
abstract class GfColors {
  static const actionBlue = Color(0xFF126AF3); // primary action / links
  static const actionBlueHover = Color(0xFF0B58D0);
  static const darkBlue = Color(0xFF11497B); // "dark-blue" hero theme
  static const deepBlue = Color(0xFF0842A0);
  static const lightBlue = Color(0xFF47A6FF);
  static const ink = Color(0xFF0C1217); // near-black text / footer
  static const red = Color(0xFFDD0028);
  static const grey100 = Color(0xFFF3F5F7); // subtle section background
  static const grey200 = Color(0xFFEDF0F2);
  static const grey300 = Color(0xFFDCE0E4);
  static const grey400 = Color(0xFFBFC8CF); // borders
  static const grey500 = Color(0xFF9CA9B5);
  static const grey600 = Color(0xFF73859F);
  static const grey700 = Color(0xFF65717B);
  static const grey800 = Color(0xFF465059);
  static const white = Color(0xFFFFFFFF);

  // Chart / accent palette (validated for light UI via dataviz skill).
  static const curveBlue = Color(0xFF0B58D0);
  static const curveMid = Color(0xFF3186F0);
  static const curveLight = Color(0xFF6FB1FA);
  static const teal = Color(0xFF00A6A6);
  static const amber = Color(0xFFF5A623);
  static const green = Color(0xFF17A66B);
}

/// Brand gradients used across heroes and feature surfaces.
abstract class GfGradients {
  static const hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [GfColors.darkBlue, GfColors.deepBlue],
  );
  static const deep = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [GfColors.deepBlue, GfColors.ink],
  );
  static const ai = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF126AF3), Color(0xFF00A6A6)],
  );
}

/// Soft elevation shadow for cards and floating surfaces.
const List<BoxShadow> gfCardShadow = [
  BoxShadow(
    color: Color(0x14000000),
    blurRadius: 24,
    offset: Offset(0, 8),
  ),
];

ThemeData grundfosTheme() {
  const base = 'Grundfos';
  return ThemeData(
    useMaterial3: true,
    fontFamily: base,
    scaffoldBackgroundColor: GfColors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: GfColors.actionBlue,
      primary: GfColors.actionBlue,
      secondary: GfColors.darkBlue,
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
      // Large headings on the site use the extended-bold cut.
      displaySmall: TextStyle(
          fontFamily: 'Grundfos-Extd',
          fontWeight: FontWeight.w700,
          color: GfColors.ink,
          height: 1.15),
      headlineMedium: TextStyle(
          fontFamily: 'Grundfos-Extd',
          fontWeight: FontWeight.w700,
          color: GfColors.ink,
          height: 1.2),
      headlineSmall: TextStyle(
          fontFamily: 'Grundfos-Extd',
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: GfColors.actionBlue,
        foregroundColor: GfColors.white,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        textStyle: const TextStyle(
            fontFamily: base, fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: GfColors.actionBlue,
        side: const BorderSide(color: GfColors.actionBlue, width: 1.5),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
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
      fillColor: GfColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: GfColors.grey400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: GfColors.grey400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: GfColors.actionBlue, width: 2),
      ),
      hintStyle: const TextStyle(color: GfColors.grey600),
    ),
    dividerTheme: const DividerThemeData(color: GfColors.grey300, thickness: 1),
    chipTheme: const ChipThemeData(
      backgroundColor: GfColors.grey100,
      side: BorderSide(color: GfColors.grey300),
      labelStyle: TextStyle(color: GfColors.ink),
    ),
  );
}
