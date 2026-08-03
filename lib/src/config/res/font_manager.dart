import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontManager {
  static String fontFamilyCairo = GoogleFonts.cairo().fontFamily!;
}

TextStyle getTextStyle() => GoogleFonts.cairo();
