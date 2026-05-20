library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

export 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared ScreenUtil configuration for the app design canvas.
class ScreenUtilConfig {
  static const designSize = Size(375, 812);
}

const double _tinySize = 5.0;
const double _smallSize = 10.0;
const double _mediumSize = 25.0;
const double _largeSize = 50.0;
const double _massiveSize = 120.0;

const SMALL_PADDING = 10.0;
const GRID_PADDING = 10.0;

final Widget horizontalSpaceTiny = SizedBox(width: _tinySize.w);
final Widget horizontalSpaceSmall = SizedBox(width: _smallSize.w);
final Widget horizontalSpaceMedium = SizedBox(width: _mediumSize.w);
final Widget horizontalSpaceLarge = SizedBox(width: _largeSize.w);

final Widget verticalSpaceTiny = SizedBox(height: _tinySize.h);
final Widget verticalSpaceSmall = SizedBox(height: _smallSize.h);
final Widget verticalSpaceMedium = SizedBox(height: _mediumSize.h);
final Widget verticalSpaceLarge = SizedBox(height: _largeSize.h);
final Widget verticalSpaceMassive = SizedBox(height: _massiveSize.h);

Widget spacedDivider = Column(
  children: <Widget>[
    verticalSpaceMedium,
    Divider(color: Colors.blueGrey, height: 5.0.h),
    verticalSpaceMedium,
  ],
);

Widget verticalSpace(double height) => SizedBox(height: height);

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenHeightFraction(
    BuildContext context, {
      int dividedBy = 1,
      double offsetBy = 0,
      double max = 3000,
    }) =>
    min((screenHeight(context) - offsetBy) / dividedBy, max);

double screenWidthFraction(
    BuildContext context, {
      int dividedBy = 1,
      double offsetBy = 0,
      double max = 3000,
    }) =>
    min((screenWidth(context) - offsetBy) / dividedBy, max);

double halfScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 2);

double thirdScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 3);

double quarterScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 4);

double getResponsiveHorizontalSpaceMedium(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 20); // Reduced from dividedBy: 10

