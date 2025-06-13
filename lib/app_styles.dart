// lib/app_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  static TextStyle getAppTextStyle({
    required double fontSize,
    double letterSpacing = 0,
    required FontWeight fontWeight,
    FontStyle fontStyle = FontStyle.normal,
    required BuildContext context,
    Color? color, 
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double adjustedFontSize = fontSize;

    if (screenWidth <= 360) {
      adjustedFontSize = fontSize * 0.85;
    } else if (screenWidth <= 420) {
      adjustedFontSize = fontSize * 0.95;
    }

    adjustedFontSize = adjustedFontSize.clamp(8.0, fontSize + 10.0);

    final textColor = color ?? Theme.of(context).textTheme.bodyLarge!.color ?? Colors.black;

    return GoogleFonts.teko(
      textStyle: TextStyle(
        fontStyle: fontStyle,
        color: textColor,
        fontSize: adjustedFontSize,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
      ),
    );
  }
}