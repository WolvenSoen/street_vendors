import 'package:flutter/material.dart';

class WolvenElevatedBtn{
  WolvenElevatedBtn._();

  // FOR LIGHT THEME

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: const Color(0xFF000000),
      backgroundColor: const Color(0xFFFA3D3B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    )
  );

  // FOR DARK THEME

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: const Color(0xFFFFFFFF),
      backgroundColor: const Color(0xFFFA3D3B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    )
  );
}