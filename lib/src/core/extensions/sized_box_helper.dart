import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ponytail: minimal 1-liner extension for SizedBox sizing
extension SizedBoxHelper on num {
  SizedBox get szH => SizedBox(height: toDouble().h);
  SizedBox get szW => SizedBox(width: toDouble().w);
}
