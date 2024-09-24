import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_colors.dart';

class ThemeClass{
static ThemeData lightTheme=ThemeData(


    colorScheme:   const ColorScheme.light(
      primary: Color(0xFF3BE477),
      onPrimary: Color(0xFFE4FEFE),
      primaryContainer: Color(0xFFB0FFFF),
      onPrimaryContainer: Color(0xFF029494),
      //onPrimaryContainer: CustomColors.grey800,

      secondary: Color(0xFF7635DC),
      onSecondary: Color(0xFFF1EBFC),
      secondaryContainer: Color(0xFFB189F1),
      onSecondaryContainer: Color(0xFF3C117E),

      error: Color(0xFFF43B00),
      onError: Color(0xFFFEC3B1),
      errorContainer:Color(0xFFFF8159),
      onErrorContainer: Color(0xFF7C2104),


    ),

    fontFamily: GoogleFonts.publicSans().fontFamily,
    primaryColor: const Color(0xFF00E7E7),
    appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black, size: 24),
        actionsIconTheme: const IconThemeData(color: Colors.black, size: 24),
        titleTextStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black),
        systemOverlayStyle:   SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        )
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: BorderSide(color:  CustomColors.grey800.withOpacity(0.6)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: CustomColors.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 16),
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
          //side: BorderSide(color:  CustomColors.primaryColor.withOpacity(0.6)),
        ),
      ),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F8F8),
    dividerTheme: const DividerThemeData(
        color: CustomColors.grey200
    )
);
}