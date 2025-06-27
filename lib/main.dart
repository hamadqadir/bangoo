import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'splash_screen.dart';

void main() {
  runApp(GetMaterialApp(
    home: SplashScreen(),
    theme: ThemeData(
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
    ),
    debugShowCheckedModeBanner: false,
  ));
}
