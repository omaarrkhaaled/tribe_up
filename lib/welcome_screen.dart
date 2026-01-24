import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/assets_managar.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/resources/styles_manager.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                UiConstants.welcomeMessage,
                textAlign: TextAlign.start,
                style: getBoldStyle(color: ColorManager.black, fontSize: 24.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                UiConstants.findYourPeople,
                style: getSemiBoldStyle(
                  color: ColorManager.grey,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 40.h),
              Image.asset(
                ImageAssets.welcomeImage,
                width: 300.w,
                height: 280.h,
              ),
              SizedBox(height: 100.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed(AppRoutesConstants.signUp);
                  },
                  child: Text(
                    UiConstants.joinNow,
                    style: getMediumStyle(
                      color: ColorManager.white,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushReplacementNamed(AppRoutesConstants.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.white,
                    foregroundColor: ColorManager.black,
                    side: BorderSide(color: ColorManager.black),
                  ),
                  child: Text(
                    UiConstants.alreadyHaveAccount,
                    style: getMediumStyle(
                      fontSize: 18.sp,
                      color: ColorManager.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              Align(
                alignment: Alignment.center,
                child: Text(
                  UiConstants.tribeUp,
                  style: getBoldStyle(
                    color: ColorManager.primary,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
