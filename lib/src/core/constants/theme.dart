import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final  darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1C78B3), brightness: Brightness.dark),
  textTheme: GoogleFonts.manropeTextTheme(
    ThemeData(brightness: Brightness.dark).textTheme,
  ),
);
