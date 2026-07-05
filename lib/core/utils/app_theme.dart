import 'package:flutter/material.dart';
import 'package:tribe_up/core/resources/color_manager.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: ColorManager.primary,
    scaffoldBackgroundColor: ColorManager.white,
    //------------------- AppBar Theme ------------------//
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
        color: ColorManager.black,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      iconTheme: IconThemeData(color: ColorManager.black),
      backgroundColor: ColorManager.white,
    ),
    //------------------- Input Decoration Theme ------------------//
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.auto,

      labelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: ColorManager.grey,
      ),

      floatingLabelStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: ColorManager.grey,
      ),

      hintStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: ColorManager.lightGrey.withValues(alpha: 0.5),
      ),

      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      border: _outline(ColorManager.grey),
      enabledBorder: _outline(ColorManager.grey),
      focusedBorder: _outline(ColorManager.primary, width: 2),
      errorBorder: _outline(ColorManager.red),
      focusedErrorBorder: _outline(ColorManager.red, width: 2),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.primary,
        foregroundColor: ColorManager.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: ColorManager.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(cursorColor: ColorManager.black),

    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: ColorManager.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: ColorManager.black,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: ColorManager.black,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        color: ColorManager.black,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: ColorManager.black,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: ColorManager.black,
      ),
    ),
  );
}

OutlineInputBorder _outline(Color color, {double width = 1}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: width),
  );
}
