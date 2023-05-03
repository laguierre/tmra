import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tmra/pages/snackbar.dart';
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

///Muestra el Nombre de la Estación y el botón de captura de pantalla
///
class TMRATopAppBar extends StatelessWidget {
  const TMRATopAppBar({
    Key? key,
    required this.info,
    required this.screenshotController,
    this.fileName = 'screenshot',
    required this.widget,
  }) : super(key: key);

  final Sensors info;
  final ScreenshotController screenshotController;
  final String fileName;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 50),
        child: Row(
          children: [
            StationName(info: info),
            const Spacer(),
            IconButton(
                onPressed: () async {
                  Uint8List? image;
                  double pixelRatio = MediaQuery.of(context).devicePixelRatio;
                  if (widget != null) {
                    /*final image = await screenshotController.capture(
                      pixelRatio: pixelRatio);*/
                    image = await screenshotController.captureFromWidget(
                      widget!,
                      context: context,
                      pixelRatio: pixelRatio,
                    );
                  } else {
                    image = await screenshotController.capture(
                        pixelRatio: pixelRatio);
                  }

                  ///Save screenshot.
                  await [Permission.storage].request();
                  final time = DateTime.now()
                      .toIso8601String()
                      .replaceAll('.', '-')
                      .replaceAll(':', '-');
                  final name = 'EM${info.em}_${fileName}_$time';
                  final result =
                      await ImageGallerySaver.saveImage(image!, name: name);
                  snackBar(context, 'Captura guardada',
                      const Duration(milliseconds: kDurationSnackBar + 1000));
                },
                icon: Image.asset(
                  screenShotLogo,
                  fit: BoxFit.fitHeight,
                  color: Colors.white,
                ))
          ],
        ));
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
