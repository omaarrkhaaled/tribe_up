import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/font_managar.dart';

TextStyle _getTextStyle(
  double fontSize,
  FontWeight fontWeight,
  Color color, {
  required String fontFamily,
  TextDecoration? decoration,
  Color? decorationColor,
  double? decorationThickness,
}) {
  switch (fontFamily.toLowerCase()) {
    case GoogleFontsKeys.poppins:
      return GoogleFonts.poppins(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
      );
    case GoogleFontsKeys.roboto:
      return GoogleFonts.roboto(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
      );
    case GoogleFontsKeys.cairo:
      return GoogleFonts.cairo(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
      );
      case 'inter':
      return GoogleFonts.inter(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
      );

    default:
      return GoogleFonts.poppins(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
      );
  }
}

TextStyle getLightStyle({
  double? fontSize,
  required Color color,

  String fontFamily = GoogleFontsKeys.roboto,

  TextDecoration? decoration,
  Color? decorationColor,
  double? decorationThickness,
}) => _getTextStyle(
  fontSize ?? FontSize.s14.sp,
  FontWeightManager.light,
  color,
  fontFamily: fontFamily,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationThickness: decorationThickness,
);

TextStyle getRegularStyle({
  double? fontSize,
  required Color color,
  String fontFamily = GoogleFontsKeys.roboto,
  TextDecoration? decoration,
  Color? decorationColor,
  double? decorationThickness,
}) => _getTextStyle(
  fontSize ?? FontSize.s14.sp,
  FontWeightManager.regular,
  color,
  fontFamily: fontFamily,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationThickness: decorationThickness,
);

TextStyle getMediumStyle({
  double? fontSize,
  required Color color,
  String fontFamily = GoogleFontsKeys.roboto,
  TextDecoration? decoration,
  Color? decorationColor,
  double? decorationThickness,
}) => _getTextStyle(
  fontSize ?? FontSize.s14.sp,
  FontWeightManager.medium,
  color,
  fontFamily: fontFamily,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationThickness: decorationThickness,
);

TextStyle getSemiBoldStyle({
  double? fontSize,
  required Color color,
  String fontFamily = GoogleFontsKeys.roboto,
  TextDecoration? decoration,
  Color? decorationColor,
  double? decorationThickness,
}) => _getTextStyle(
  fontSize ?? FontSize.s14.sp,
  FontWeightManager.semiBold,
  color,
  fontFamily: fontFamily,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationThickness: decorationThickness,
);
TextStyle getBoldStyle({
  double? fontSize,
  required Color color,
  String fontFamily = GoogleFontsKeys.roboto,
  TextDecoration? decoration,
  Color? decorationColor,
  double? decorationThickness,


}) => _getTextStyle(
  fontSize ?? FontSize.s14.sp,
  FontWeightManager.bold,
  color,
  fontFamily: fontFamily,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationThickness: decorationThickness,
);
