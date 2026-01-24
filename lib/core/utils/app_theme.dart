import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/resources/font_managar.dart';
import 'package:tribe_up/core/resources/styles_manager.dart';
import 'package:tribe_up/core/resources/values_managar.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: ColorManager.primary,
    scaffoldBackgroundColor: ColorManager.white,
    //------------------- AppBar Theme ------------------//
    appBarTheme: AppBarTheme(
      titleTextStyle: getMediumStyle(
        color: ColorManager.black,
        fontSize: FontSize.s20,
        fontFamily: GoogleFontsKeys.inter,
      ),
      iconTheme: IconThemeData(color: ColorManager.black),
      backgroundColor: ColorManager.white,
    ),
    //------------------- Input Decoration Theme ------------------//
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.auto,

      labelStyle: getRegularStyle(color: ColorManager.grey),

      floatingLabelStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeightManager.regular,
        color: ColorManager.grey,        
      ),

      hintStyle: TextStyle(
        fontSize: FontSize.s12.sp,
        fontWeight: FontWeightManager.regular,
        color: ColorManager.lightGrey,
      ),

      contentPadding: EdgeInsets.symmetric(
        horizontal: Insets.s16.sp,
        vertical: Insets.s16.sp,
      ),

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: ColorManager.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(cursorColor: ColorManager.black),
  );
}

OutlineInputBorder _outline(Color color, {double width = 1}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: BorderSide(color: color, width: width),
  );
}
