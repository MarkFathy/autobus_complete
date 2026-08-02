import 'package:flutter/material.dart';

class FontManager {
  static const String fontFamilyCairo = 'Cairo';
}

TextStyle getTextStyle() => const TextStyle(fontFamily: FontManager.fontFamilyCairo);
