import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void snackBar(BuildContext context, String text, Duration duration) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: duration,
      backgroundColor: Colors.amberAccent,
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Text(text,
          textScaleFactor: 1.0,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 17.sp))));
}
