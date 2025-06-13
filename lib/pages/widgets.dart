import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants.dart';
import '../models/model_sensors.dart';

class StationName extends StatelessWidget {
  const StationName({
    super.key,
    required this.info,
  });

  final Sensors info;

  @override
  Widget build(BuildContext context) {
    return Text('Estación ${info.em}',
        style: TextStyle(
            color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold));
  }
}

/// Crea una linea con un ícono si está presente, un texto en normal y el siguiente el BOLD
class InfoConfig extends StatelessWidget {
  const InfoConfig({
    Key? key,
    required this.title,
    required this.value,
    this.size = kFontSize,
    required this.icon,
    this.color = Colors.white,
  }) : super(key: key);

  final String title;
  final String value;
  final double size;
  final String icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 7),
        alignment: Alignment.centerLeft,
        width: double.infinity,
        height: 40,
        child: Row(
          children: [
            if (icon != '') Image.asset(icon, color: color, height: 22.sp),
            if (icon != '')  SizedBox(width: 12.sp),
            Expanded(
                child: Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: title,
                    style: TextStyle(fontSize: size, color: color)),
                TextSpan(
                    text: value,
                    style: TextStyle(
                        fontSize: size,
                        color: color,
                        fontWeight: FontWeight.bold)),
              ]),
            ))
          ],
        ));
  }
}

Future<void> writeScreenshotFile(String fileName, Uint8List file2Write) async {
  await Permission.storage.request();
  final time = DateTime.now()
      .toIso8601String()
      .replaceAll('.', '-')
      .replaceAll(':', '-');

  var hasStoragePermission = await Permission.manageExternalStorage.isGranted;
  if (!hasStoragePermission) {
    await Permission.manageExternalStorage.request().isGranted;
    debugPrint('Has Permission');
  } else {
    debugPrint('Has not Permission!!!');
  }
  var downloadsDirectoryPath = (await DownloadsPath.downloadsDirectory())?.path;
  String path2Download = '$downloadsDirectoryPath/${fileName}_$time.jpg';
  File(path2Download).writeAsBytes(file2Write);
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final String icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        iconSize: 45.sp,
        splashColor: kSplashColor,
        onPressed: onPressed,
        icon: Image.asset(
          icon,
          fit: BoxFit.fitHeight,
          color: Colors.white,
        ));
  }
}

