import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
    final android13OrAbove = await Permission.photos.isGranted ||
        await Permission.photos.request().isGranted;

    final legacyStorageGranted = await Permission.storage.request().isGranted;

    if (!android13OrAbove && !legacyStorageGranted) {
      debugPrint("❌ Permiso de almacenamiento o fotos denegado.");
      return "Permiso de almacenamiento o fotos denegado";
    }

    // 🕒 Formato seguro: [YYYY-MM-DD, HHmm]
    final now = DateTime.now();
    final formatter = DateFormat("yyyy-MM-dd, HHmm");
    final timestamp = formatter.format(now);

    // Quitar extensión .jpg si la tiene
    String nameWithoutExt = fileName.replaceAll(RegExp(r'\.jpg$', caseSensitive: false), '');

    // 🧠 Extraer nombre que empieza con EM (como EMTEST, EM20)
    final match = RegExp(r'^(EM[^_]+)').firstMatch(nameWithoutExt);
    final emFolder = match != null ? match.group(1)! : 'default';

    // 📄 Nombre final del archivo
    final newFileName = "$nameWithoutExt [$timestamp].jpg";

    // 📁 Crear carpeta /Download/TMRA/EMxx/
    final directory = Directory('/storage/emulated/0/Download/TMRA/$emFolder');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final path = '${directory.path}/$newFileName';
    final file = File(path);
    await file.writeAsBytes(imageBytes);

    debugPrint("✅ Imagen guardada en: $path");
    return path;
  } catch (e) {
    debugPrint("❌ Error al guardar la captura: $e");
    return null;
  }
}
// Future<String?> writeScreenshotFile(String fileName, Uint8List imageBytes) async {
//   try {
//     final android13OrAbove = await Permission.photos.isGranted ||
//         await Permission.photos.request().isGranted;
//
//     final legacyStorageGranted = await Permission.storage.request().isGranted;
//
//     if (!android13OrAbove && !legacyStorageGranted) {
//       debugPrint("❌ Permiso de almacenamiento o fotos denegado.");
//       return "Permiso de almacenamiento o fotos denegado";
//     }
//
//     // Timestamp
//     final now = DateTime.now();
//     final formatter = DateFormat('yyyyMMdd_HHmmss');
//     final timestamp = formatter.format(now);
//
//     // Quitar extensión .jpg si la tiene
//     String nameWithoutExt = fileName.replaceAll(RegExp(r'\.jpg$', caseSensitive: false), '');
//
//     // Detectar sufijo "_download"
//     const suffix = '_download';
//     String baseName;
//     if (nameWithoutExt.endsWith(suffix)) {
//       baseName = nameWithoutExt.substring(0, nameWithoutExt.length - suffix.length);
//     } else {
//       baseName = nameWithoutExt;
//     }
//
//     // Extraer el prefijo EMxx (hasta "_" o fin)
//     final match = RegExp(r'^(EM[^_]+)').firstMatch(baseName);
//     final subfolder = match != null ? match.group(1)! : 'default';
//
//     // Nombre de archivo final
//     final newFileName = '${baseName}_$timestamp${nameWithoutExt.endsWith(suffix) ? suffix : ''}.jpg';
//
//     // Crear carpeta en /Download/TMRA/EMxx/
//     final directory = Directory('/storage/emulated/0/Download/TMRA/$subfolder');
//     if (!await directory.exists()) {
//       await directory.create(recursive: true);
//     }
//
//     final path = '${directory.path}/$newFileName';
//     final file = File(path);
//     await file.writeAsBytes(imageBytes);
//
//     debugPrint("✅ Imagen guardada en: $path");
//     return path;
//   } catch (e) {
//     debugPrint("❌ Error al guardar la captura: $e");
//     return null;
//   }
// }

/**Funciona*/
// Future<String?> writeScreenshotFile(
//     String fileName, Uint8List imageBytes) async {
//   try {
//     final android13OrAbove = await Permission.photos.isGranted ||
//         await Permission.photos.request().isGranted;
//
//     final legacyStorageGranted = await Permission.storage.request().isGranted;
//
//     if (!android13OrAbove && !legacyStorageGranted) {
//       debugPrint("Permiso de almacenamiento o fotos denegado.");
//       return "Permiso de almacenamiento o fotos denegado";
//     }
//
//     final result = await ImageGallerySaver.saveImage(
//       imageBytes,
//       name: fileName,
//       quality: 100,
//     );
//
//     if (result['isSuccess'] == true) {
//       debugPrint("✅ Imagen guardada en la galería.");
//     } else {
//       debugPrint("❌ Error al guardar imagen: $result");
//       return "Error al guardar imagen: $result";
//     }
//     return "Archivo guardado en Galería";
//   } catch (e) {
//     debugPrint("Error al guardar la captura: $e");
//     return null;
//   }
// }

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
