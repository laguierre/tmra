import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
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
        style: const TextStyle(
            color: Colors.white,
            fontSize: kFontSize + 4,
            fontWeight: FontWeight.bold));
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
            if (icon != '') Image.asset(icon, color: color, height: 30),
            if (icon != '') const SizedBox(width: 12),
            Expanded(
                child: AutoSizeText.rich(
              TextSpan(children: [
                TextSpan(text: title, style: TextStyle(color: color)),
                TextSpan(
                    text: value,
                    style:
                        TextStyle(color: color, fontWeight: FontWeight.bold)),
              ]),
              minFontSize: size,
              maxFontSize: size + 1,
              stepGranularity: 0.1,
            ))
          ],
        ));
  }
}
Future<void> downloadScreenshotFile(String fileName, Uint8List file2Write) async {
  await Permission.storage.request();
  final time = DateTime.now()
      .toIso8601String()
      .replaceAll('.', '-')
      .replaceAll(':', '-');

  var hasStoragePermission =
  await Permission.manageExternalStorage.isGranted;
  if (!hasStoragePermission) {
    final status =
    await Permission.manageExternalStorage.request().isGranted;
    debugPrint('Has Permission');
  } else {
    debugPrint('Has not Permission!!!');
  }
  var downloadsDirectoryPath =
      (await DownloadsPath.downloadsDirectory())?.path;
  String path2Download = '$downloadsDirectoryPath/${fileName}_$time.jpg';
  File(path2Download).writeAsBytes(file2Write);

  //Guardar la imagen en la galería de imágenes del dispositivo
  /*print(await ImageGallerySaver.saveImage(
     file2Write, name: '${fileName}_$time'));*/
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
        iconSize: 45,
        splashColor: kSplashColor,
        onPressed: onPressed,
        icon: Image.asset(
          icon,
          fit: BoxFit.fitHeight,
          color: Colors.white,
        ));
  }
}
///Código muerto - Captura de Pantalla via RenderRepaintBoundary
/*
void _captureScreenshot() async {
  RenderRepaintBoundary boundary =
  _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
  if (boundary.debugNeedsPaint) {
    Timer(const Duration(seconds: 1), () => _captureScreenshot());
    return null;
  }
  ui.Image image = await boundary.toImage();
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (ByteData != null) {
    Uint8List pngInt8 = byteData!.buffer.asUint8List();
    final saveImage = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngInt8),
        quality: 90,
        name: 'prueba - ${DateTime.now()}.png');
  }
}*/
