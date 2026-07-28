import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppMargin {
  // VALUES FOR HEIGHT
  static double mH2 = 2.0.h;
  static double mH4 = 4.0.h;
  static double mH8 = 8.0.h;
  static double mH10 = 10.0.h;
  static double mH12 = 12.0.h;
  static double mH14 = 14.0.h;
  static double mH16 = 16.0.h;
  static double mH18 = 18.0.h;
  static double mH20 = 20.0.h;

  // VALUES FOR WIDTH
  static double mW2 = 2.0.w;
  static double mW4 = 4.0.w;
  static double mW8 = 8.0.w;
  static double mW10 = 10.0.w;
  static double mW12 = 12.0.w;
  static double mW14 = 14.0.w;
  static double mW16 = 16.0.w;
  static double mW18 = 18.0.w;
  static double mW20 = 20.0.w;
}

class AppPadding {
  // VALUES FOR HEIGHT
  static double pH1 = 1.0.h;
  static double pH2 = 2.0.h;
  static double pH4 = 4.0.h;
  static double pH5 = 5.0.h;
  static double pH6 = 6.0.h;
  static double pH8 = 8.0.h;
  static double pH10 = 10.0.h;
  static double pH12 = 12.0.h;
  static double pH14 = 14.0.h;
  static double pH16 = 16.0.h;
  static double pH18 = 18.0.h;
  static double pH20 = 20.0.h;
  static double pH22 = 22.0.h;
  static double pH24 = 24.0.h;
  static double pH28 = 28.0.h;
  static double pH30 = 30.0.h;
  static double pH32 = 32.0.h;
  static double pH50 = 50.0.h;

  // VALUES FOR WIDTH
  static double pW2 = 2.0.h;
  static double pW4 = 4.0.h;
  static double pW5 = 5.0.h;
  static double pW8 = 8.0.w;
  static double pW10 = 10.0.w;
  static double pW12 = 12.0.w;
  static double pW14 = 14.0.w;
  static double pW16 = 16.0.w;
  static double pW18 = 18.0.w;
  static double pW20 = 20.0.w;
  static double pW24 = 24.0.w;
  static double pW30 = 30.0.w;
  static double pW40 = 40.0.w;
  static double pW50 = 50.0.w;
  static double pW60 = 60.0.w;


  static double paddingScreenTop = Platform.isAndroid
      ? (AppSize.sH25 + pH8)
      : pH50;
  static double paddingScreenBottom = Platform.isAndroid ? pH24 : pH32;
}

class AppSize {
  // VALUES FOR HEIGHT
  static double sH0 = 0.0.h;
  static double sH1 = 1.0.h;
  static double sH2 = 2.0.h;
  static double sH3 = 3.0.h;
  static double sH4 = 4.0.h;
  static double sH5 = 5.0.h;
  static double sH6 = 6.0.h;
  static double sH8 = 8.0.h;
  static double sH10 = 10.0.h;
  static double sH12 = 12.0.h;
  static double sH14 = 14.0.h;
  static double sH16 = 16.0.h;
  static double sH18 = 18.0.h;
  static double sH20 = 20.0.h;
  static double sH24 = 24.0.h;
  static double sH25 = 25.0.h;
  static double sH28 = 28.0.h;
  static double sH29 = 29.0.h;
  static double sH30 = 30.0.h;
  static double sH32 = 32.0.h;
  static double sH34 = 34.0.h;
  static double sH35 = 35.0.h;
  static double sH36 = 36.0.h;
  static double sH40 = 40.0.h;
  static double sH45 = 45.0.h;
  static double sH48 = 48.0.h;
  static double sH50 = 50.0.h;
  static double sH55 = 55.0.h;
  static double sH56 = 56.0.h;
  static double sH60 = 60.0.h;
  static double sH64 = 64.0.h;
  static double sH65 = 65.0.h;
  static double sH70 = 70.0.h;
  static double sH72 = 72.0.h;
  static double sH75 = 75.0.h;
  static double sH80 = 80.0.h;
  static double sH85 = 85.0.h;
  static double sH90 = 90.0.h;
  static double sH100 = 100.0.h;
  static double sH110 = 110.0.h;
  static double sH115 = 115.0.h;
  static double sH120 = 120.0.h;
  static double sH130 = 130.0.h;
  static double sH140 = 140.0.h;
  static double sH150 = 150.0.h;
  static double sH160 = 160.0.h;
  static double sH200 = 200.0.h;
  static double sH250 = 250.0.h;
  static double sH270 = 270.0.h;
  static double sH300 = 300.0.h;
  static double sH360 = 360.0.h;

  // VALUES FOR WIDTH
  static double sW0 = 0.0.w;
  static double sW2 = 2.0.w;
  static double sW4 = 4.0.w;
  static double sW5 = 5.0.w;
  static double sW6 = 6.0.w;
  static double sW8 = 8.0.w;
  static double sW10 = 10.0.w;
  static double sW12 = 12.0.w;
  static double sW14 = 14.0.w;
  static double sW16 = 16.0.w;
  static double sW18 = 18.0.w;
  static double sW20 = 20.0.w;
  static double sW24 = 24.0.w;
  static double sW25 = 25.0.w;
  static double sW30 = 30.0.w;
  static double sW32 = 32.0.w;
  static double sW35 = 35.0.w;
  static double sW39 = 39.0.w;
  static double sW40 = 40.0.w;
  static double sW45 = 45.0.w;
  static double sW48 = 48.0.w;
  static double sW50 = 50.0.w;
  static double sW60 = 60.0.w;
  static double sW64 = 64.0.w;
  static double sW65 = 65.0.w;
  static double sW70 = 70.0.w;
  static double sW75 = 75.0.w;
  static double sW80 = 80.0.w;
  static double sW90 = 90.0.w;
  static double sW100 = 100.0.w;
  static double sW120 = 120.0.w;
  static double sW125 = 125.0.w;
  static double sW140 = 140.0.w;
  static double sW150 = 150.0.w;
  static double sW165 = 165.0.w;
  static double sW175 = 175.0.w;
  static double sW180 = 180.0.w;
  static double sW190 = 190.0.w;
  static double sW200 = 200.0.w;
  static double sW230 = 230.0.w;
  static double sW250 = 250.0.w;
  static double sW290 = 290.0.w;
}

class FontSize {
  static double s6 = 6.0.sp;
  static double s8 = 8.0.sp;
  static double s10 = 10.0.sp;
  static double s11 = 11.0.sp;
  static double s12 = 12.0.sp;
  static double s13 = 13.0.sp;
  static double s14 = 14.0.sp;
  static double s15 = 15.0.sp;
  static double s16 = 16.0.sp;
  static double s18 = 18.0.sp;
  static double s20 = 20.0.sp;
  static double s22 = 22.0.sp;
  static double s24 = 24.0.sp;
}

class ScreenSizes {
  static double width = 375;
  static double height = 812;
}

class AppCircular {
  static double r2 = 2.0.r;
  static double r3 = 3.0.r;
  static double r4 = 4.0.r;
  static double r5 = 5.0.r;
  static double r6 = 6.0.r;
  static double r7 = 7.0.r;
  static double r8 = 8.0.r;
  static double r10 = 10.0.r;
  static double r12 = 12.0.r;
  static double r15 = 15.0.r;
  static double r16 = 16.0.r;
  static double r20 = 20.0.r;
  static double r24 = 24.0.r;
  static double r29 = 29.0.r;
  static double r32 = 32.0.r;
  static double r40 = 40.0.r;
  static double r48 = 48.0.r;
}
