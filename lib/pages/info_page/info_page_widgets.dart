import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:tmra/models/model_sensors.dart';
import 'package:tmra/pages/widgets.dart';
import 'package:widget_screenshot/widget_screenshot.dart';
import '../../constants.dart';
import '../snackbar.dart';

class EMInfo extends StatelessWidget {
  const EMInfo({
    super.key,
    required this.info,
    required this.size,
    required this.scrollController,
    required this.infoKey,
  });

  final Sensors info;
  final Size size;
  final ScrollController scrollController;
  final GlobalKey infoKey;

  @override
  Widget build(BuildContext context) {
    double fontSize = 15.sp;
    double fontSizeTitle = 18.sp;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.only(top: 50),
            child: SizedBox(
              height: 40.sp,
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
                        String? file;
                        file = await writeScreenshotFile('EM${info.em}_info', image!);
                        snackBar(
                            context,
                            file!,
                            const Duration(
                                milliseconds: kDurationSnackBar + 1000));
                      },
                      icon: Image.asset(
                        screenShotLogo,
                        fit: BoxFit.fitHeight,
                        color: Colors.white,
                      ))
                ],
              ),
            )),
        const Divider(
          height: 10,
          color: Colors.white,
        ),
        Container(
          margin: EdgeInsets.only(top: 20.sp, bottom: 10.sp),
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(color: Colors.white),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoConfig(
                title: '',
                value: 'WiFi Board Info',
                icon: wifiIcon,
                size: fontSizeTitle,
              ),
              InfoConfig(
                  icon: '',
                  title: 'Sw version: ',
                  value: info.wifi![0],
                  size: fontSize),
              InfoConfig(
                  icon: '',
                  title: 'Hw version: ',
                  value: info.wifi![1],
                  size: fontSize),
            ],
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0.sp)),
              border: Border.all(color: Colors.white),
            ),
            child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoConfig(
                      icon: cpuIcon,
                      title: '',
                      value: 'CPU Board Info',
                      size: fontSizeTitle,
                    ),
                    InfoConfig(
                        icon: '',
                        title: 'Sw version: ',
                        value: info.cpu![0],
                        size: fontSize),
                    InfoConfig(
                        icon: '',
                        title: 'Hw version: ',
                        value: info.cpu![1],
                        size: fontSize),
                    InfoConfig(
                        title: 'Channel Used [0]: ',
                        value: info.channelUsed![0],
                        size: fontSize,
                        icon: ""),
                    InfoConfig(
                        title: 'Channel Used [1]: ',
                        value: info.channelUsed![1],
                        size: fontSize,
                        icon: ""),
                    InfoConfig(
                        title: 'Controlled Channel Used [0]: ',
                        value: info.controlledChannel![0],
                        size: fontSize,
                        icon: ""),
                    InfoConfig(
                        title: 'Controlled Channel Used [1]: ',
                        value: info.controlledChannel![1],
                        size: fontSize,
                        icon: ""),
                  ],
                ))),
        Container(
            margin: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0.sp)),
              border: Border.all(color: Colors.white),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoConfig(
                    size: fontSizeTitle,
                    title: '',
                    value: 'DAQ Board Info',
                    icon: adcIcon),
                InfoConfig(
                    icon: '',
                    title: 'Sw version: ',
                    value: info.daq![0],
                    size: fontSize),
                InfoConfig(
                    icon: '',
                    title: 'Hw version: ',
                    value: info.daq![1],
                    size: fontSize),
              ],
            )),
      ],
    );
  }
}