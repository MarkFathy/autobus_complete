import 'package:flutter/material.dart';

class FontManager {
  static const String fontFamilyCairo = "Cairo";
}

TextStyle getTextStyle() {
  return const TextStyle(fontFamily: FontManager.fontFamilyCairo);
}
