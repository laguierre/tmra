import 'package:flutter/material.dart';

import 'package:tmra/models/model_sensors.dart';
import 'package:tmra/pages/widgets.dart';
import 'package:widget_screenshot/widget_screenshot.dart';
import '../../constants.dart';
import '../snackbar.dart';

class EMInfo extends StatelessWidget {
  const EMInfo({
    super.key,
    required this.info,
    required this.size, required this.scrollController, required this.infoKey,
  });

  final Sensors info;
  final Size size;
  final ScrollController scrollController;
  final GlobalKey infoKey;

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
                  splashColor: kSplashColor,
                    onPressed: () async {
                      WidgetShotRenderRepaintBoundary sensorsBoundary =
                      infoKey.currentContext!.findRenderObject()
                      as WidgetShotRenderRepaintBoundary;
                      var image = await sensorsBoundary.screenshot(
                          backgroundColor: Colors.black,
                          format: ShotFormat.png,
                          scrollController: scrollController,

                          pixelRatio: 1);
                      writeScreenshotFile('EM${info.em}_info', image!);
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
