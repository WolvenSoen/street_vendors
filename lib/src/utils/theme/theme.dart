import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:street_vendors/src/utils/theme/elevated_button_theme.dart';
import 'package:street_vendors/src/utils/theme/text_theme.dart';

class WolvenTheme {
  WolvenTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.montserrat().fontFamily,
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFA3D3B),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    textTheme: WolvenTextTheme.lightTextTheme,
    elevatedButtonTheme: WolvenElevatedBtn.lightElevatedButtonTheme
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.montserrat().fontFamily,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFFA3D3B),
    scaffoldBackgroundColor: const Color(0xFF000000),
    textTheme: WolvenTextTheme.lightTextTheme,
    elevatedButtonTheme: WolvenElevatedBtn.darkElevatedButtonTheme
  );
}