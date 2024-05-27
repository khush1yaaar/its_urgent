import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFCEF9FF), brightness: Brightness.dark),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.nunito(fontSize: 14.0),
    bodyMedium: GoogleFonts.nunito(fontSize: 16.0),
    displayLarge:
        GoogleFonts.spectral(fontSize: 32.0, fontWeight: FontWeight.bold),
    displayMedium:
        GoogleFonts.spectral(fontSize: 24.0, fontWeight: FontWeight.bold),
    displaySmall:
        GoogleFonts.spectral(fontSize: 20.0, fontWeight: FontWeight.bold),
    headlineMedium:
        GoogleFonts.spectral(fontSize: 18.0, fontWeight: FontWeight.bold),
    headlineSmall:
        GoogleFonts.spectral(fontSize: 16.0, fontWeight: FontWeight.bold),
    titleLarge:
        GoogleFonts.spectral(fontSize: 14.0, fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.nunito(fontSize: 16.0),
    titleSmall: GoogleFonts.nunito(fontSize: 14.0),
    bodySmall: GoogleFonts.nunito(fontSize: 12.0),
    labelLarge: GoogleFonts.nunito(fontSize: 14.0),
    labelSmall: GoogleFonts.nunito(fontSize: 10.0),
  ),
);
