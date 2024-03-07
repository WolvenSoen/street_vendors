import 'package:flutter/material.dart';

class WolvenTextFormFieldTheme {
  WolvenTextFormFieldTheme._();

  static final lightInputTextDecoration = InputDecorationTheme(
    labelStyle: const TextStyle(
      color: Colors.black,
    ),
    fillColor: const Color(0xFFFFFFFF),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.black,
        width: 2,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    ),
  );

  static final darkInputTextDecoration = InputDecorationTheme(
    labelStyle: const TextStyle(
      color: Colors.white,
    ),
    // ALL BLACK COLOR
    fillColor: const Color(0xFF000000),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
  );
}
