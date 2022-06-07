// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AppTextStyle {
  static const double HeaderTextSize = 18;
  static const double TitleTextSize = 17;
  static const double SubTitleTextSize = 16;
  static const double BodyTextSize = 15;
  static const double SmallTextSize = 14;
  static const double ExtraSmallTextSize = 12;

  static const TextTheme AppTextTheme = TextTheme(
    caption: TextStyle(color: AppColor.Primary, fontWeight: FontWeight.bold, fontSize: 36),
    headline6: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: HeaderTextSize),
    subtitle2: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: SubTitleTextSize),
    bodyText1: TextStyle(color: Colors.black87, fontWeight: FontWeight.normal, fontSize: BodyTextSize),
    bodyText2: TextStyle(color: Colors.black54, fontWeight: FontWeight.normal, fontSize: BodyTextSize),
    button: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: SubTitleTextSize),
    subtitle1: TextStyle(color: AppColor.Primary, fontWeight: FontWeight.normal, fontSize: SubTitleTextSize),
    headline5: TextStyle(color: AppColor.Primary, fontWeight: FontWeight.normal, fontSize: 20),
    headline4: TextStyle(color: Colors.black87, fontWeight: FontWeight.normal, fontSize: 18),
    headline3: TextStyle(color: Colors.black87, fontWeight: FontWeight.normal, fontSize: SubTitleTextSize),
    headline2: TextStyle(color: AppColor.Primary, fontWeight: FontWeight.normal, fontSize: 16),
    headline1: TextStyle(color: AppColor.Primary, fontWeight: FontWeight.normal, fontSize: 16),
    overline: TextStyle(color: AppColor.Secondary, fontWeight: FontWeight.normal, fontSize: 16),
  );
}

class AppColor {
  static const Primary = Color(0xFF0181cc);
  static const PrimaryDark = Color(0xff0169a7);
  static const PrimaryLight = Color(0xFF039be6);

  static const Secondary = Color(0xffF58025);
  static const BackgroundGrey = Color(0xE9FFFFFF);
  static const EditTextUnderlineColor = Color(0xFFCCCCCC);
}

class AppDimension {
  static const ButtonHeight = 60.0;
  static const IconSizeNormal = 25.0;
  static const IconSizeSmall = 20.0;
  static const IconSizeLarge = 30.0;
  static const IconSizeExtraLarge = 40.0;
}
