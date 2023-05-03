import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tmra/models/model_sensors.dart';
import 'package:tmra/pages/widgets.dart';
import '../../constants.dart';
import '../snackbar.dart';

class EMInfo extends StatelessWidget {
  const EMInfo({
    super.key,
    required this.info,
    required this.screenshotController,
    required this.size,
  });

  final Sensors info;
  final ScreenshotController screenshotController;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.only(top: 50),
            child: Row(
              children: [
                StationName(info: info),
                const Spacer(),
                IconButton(
                    onPressed: () async {
                      double pixelRatio =
                          MediaQuery.of(context).devicePixelRatio;
                      final image =
                          await screenshotController.captureFromWidget(
                        EMInfo(
                            info: info,
                            screenshotController: screenshotController,
                            size: size),
                        context: context,
                        pixelRatio: pixelRatio,
                        targetSize: size * 1.5,
                      );
                      //Save screenshot.
                      await [Permission.storage].request();
                      final time = DateTime.now()
                          .toIso8601String()
                          .replaceAll('.', '-')
                          .replaceAll(':', '-');
                      final name = 'EM${info.em}_info_$time';
                      final result =
                          await ImageGallerySaver.saveImage(image, name: name);
                      snackBar(
                          context,
                          'Captura guardada',
                          const Duration(
                              milliseconds: kDurationSnackBar + 1000));
                    },
                    icon: Image.asset(
                      screenShotLogo,
                      fit: BoxFit.fitHeight,
                      color: Colors.white,
                    ))
              ],
            )),
        Container(
          margin: const EdgeInsets.only(top: 30, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(color: Colors.white),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InfoConfig(
                title: '',
                value: 'WiFi Board Info',
                icon: wifiIcon,
              ),
              InfoConfig(
                  icon: '',
                  title: 'Sw version: ',
                  value: info.wifi![0],
                  size: kFontSize - 4),
              InfoConfig(
                  icon: '',
                  title: 'Hw version: ',
                  value: info.wifi![1],
                  size: kFontSize - 4),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(color: Colors.white),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InfoConfig(
                  icon: cpuIcon, title: '', value: 'CPU Board Info'),
              InfoConfig(
                  icon: '',
                  title: 'Sw version: ',
                  value: info.cpu![0],
                  size: kFontSize - 4),
              InfoConfig(
                  icon: '',
                  title: 'Hw version: ',
                  value: info.cpu![1],
                  size: kFontSize - 4),
              InfoConfig(
                  title: 'Channel Used [0]: ',
                  value: info.channelUsed![0],
                  size: kFontSize - 4,
                  icon: ""),
              InfoConfig(
                  title: 'Channel Used [1]: ',
                  value: info.channelUsed![1],
                  size: kFontSize - 4,
                  icon: ""),
              InfoConfig(
                  title: 'Controlled Channel Used [0]: ',
                  value: info.controlledChannel![0],
                  size: kFontSize - 4,
                  icon: ""),
              InfoConfig(
                  title: 'Controlled Channel Used [1]: ',
                  value: info.controlledChannel![1],
                  size: kFontSize - 4,
                  icon: ""),
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              border: Border.all(color: Colors.white),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoConfig(
                    title: '', value: 'DAQ Board Info', icon: adcIcon),
                InfoConfig(
                    icon: '',
                    title: 'Sw version: ',
                    value: info.daq![0],
                    size: kFontSize - 4),
                InfoConfig(
                    icon: '',
                    title: 'Hw version: ',
                    value: info.daq![1],
                    size: kFontSize - 4),
              ],
            )),
      ],
    );
  }
}
