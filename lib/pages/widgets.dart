import 'dart:io';
import 'package:file_saver/file_saver.dart';
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
            if (icon != '') SizedBox(width: 12.sp),
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

Future<String?> writeScreenshotFile(String fileName, Uint8List imageBytes) async {
  try {
    // Limpia el nombre del archivo
    final safeFileName = fileName.replaceAll(RegExp(r'[^\w\s_-]'), '_');

    final savedPath = await FileSaver.instance.saveFile(
      name: safeFileName,
      bytes: imageBytes,
      ext: 'png',
      mimeType: MimeType.png,
    );

    if (savedPath != null) {
      debugPrint("Captura guardada en: $savedPath");
    } else {
      debugPrint("No se pudo guardar la captura.");
    }

    return savedPath;
  } catch (e) {
    debugPrint("Error al guardar la captura: $e");
    return null;
  }
}

// Future<String?> writeScreenshotFile(
//     String fileName, Uint8List imageBytes) async {
//   try {
//     // Obtener la ruta del directorio de descargas
//     final downloadsDirectory = await DownloadsPath.downloadsDirectory();
//     if (downloadsDirectory == null) {
//       debugPrint("No se pudo obtener el directorio de descargas.");
//       return "Error";
//     }
//     final filePath = '${downloadsDirectory.path}/$fileName.png';
//     final file = File(filePath);
//
//     await file.writeAsBytes(imageBytes);
//     debugPrint("Captura guardada en: $filePath");
//     return filePath;
//   } catch (e) {
//     debugPrint("Error al guardar la captura: $e");
//   }
//   return null;
// }

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