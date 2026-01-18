import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tribe_up/core/resources/assets_managar.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/resources/styles_manager.dart';
import 'package:tribe_up/core/resources/values_managar.dart';

class UIUtils {
  static void showEasyLoading({String? status}) {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..indicatorSize = 60.0
      ..loadingStyle = EasyLoadingStyle.custom
      ..radius = 20.0
      ..backgroundColor = ColorManager.primary.withOpacity(0.85)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskType = EasyLoadingMaskType.black
      ..contentPadding = EdgeInsets.all(20);
    EasyLoading.show(status: status ?? 'Loading...');
  }

  static void hideEasyLoading() => EasyLoading.dismiss();

  static void showPremiumLoading(
    BuildContext context, {
    String? text,
    required String status,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Dialog(
          shape: BeveledRectangleBorder(),
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(40.w),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: SizedBox(
              width: 130,
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.primary,
                      ColorManager.primary.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      AnimationAssets.loadingAnimation,
                      width: 100.w,
                      height: 100.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 15.h),
                    Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: Colors.yellowAccent,
                      child: Text(
                        text ?? 'Loading...',
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: Sizes.s18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void hideLoading(BuildContext context) => Navigator.of(context).pop();

  static void showPremiumMessage(
    BuildContext context,
    String message, {
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ColorManager.primary,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              SizedBox(width: 10.w),
            ],
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.yellowAccent,
                child: Text(
                  message,
                  style: getBoldStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showDotLottieLoadingOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => Center(
        child: Lottie.asset(
          AnimationAssets.trailLoading,
          width: 300.w,
          height: 300.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  static void showPremiumDialog({
    required BuildContext context,
    String? title,
    required String message,
    String? posActionName,
    Function? posAction,
    String? negActionName,
    Function? negAction,
  }) {
    List<Widget> actions = [];

    if (negActionName != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            negAction?.call();
          },
          child: Text(
            negActionName,
            style: getMediumStyle(color: Colors.black, fontSize: 18.sp),
          ),
        ),
      );
    }

    if (posActionName != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            posAction?.call();
          },
          child: Text(
            posActionName,
            style: getMediumStyle(color: Colors.black, fontSize: 18.sp),
          ),
        ),
      );
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dialog",
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Align(
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.grey.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null && title.isNotEmpty)
                      Text(
                        title,
                        style: getBoldStyle(
                          color: ColorManager.primary,
                          fontSize: 22.sp,
                        ),
                      ),
                    SizedBox(height: 10.h),
                    Text(
                      message,
                      style: getRegularStyle(
                        color: Colors.black87,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.elasticOut),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }
}
