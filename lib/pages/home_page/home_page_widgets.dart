import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tmra/pages/widgets.dart';
import 'package:widget_screenshot/widget_screenshot.dart';

import '../../models/model_sensors.dart';
import '../../models/sensors_type.dart';
import '../snackbar.dart';
import '../../common.dart'; // Importa funciones y clases comunes

import '../../constants.dart'; // Aquí asumo que tienes constantes como kPadding, kSplashColor, etc.

class SensorCard extends StatelessWidget {
  const SensorCard({Key? key, required this.info, required this.index})
      : super(key: key);
  final SensorType info;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: _ImageSensor(
              info: info,
              height: 90.sp,
            )),
        Expanded(
            flex: 2,
            child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: kPadding),
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 5,
                      blurRadius: 13,
                      offset: const Offset(1, 5), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 0),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: info.variableName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text.rich(TextSpan(
                        text: info.variableName[index],
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(
                              text: '\n${info.variableValue[index]}\n',
                              style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.bold)),
                        ]));
                  },
                ))),
      ],
    );
  }
}

class _ImageSensor extends StatelessWidget {
  const _ImageSensor({
    required this.info,
    required this.height,
  });

  final SensorType info;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          info.imageSensor,
          height: height * 0.68,
          fit: BoxFit.fitHeight,
        ),
        const SizedBox(height: 10),
        Text(
          info.sensorName,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 19.sp),
        ),
      ],
    );
  }
}

class HomePageTopAppBar extends StatelessWidget {
  const HomePageTopAppBar({
    Key? key,
    required this.info,
    required this.testMode,
    required this.timeDownload,
    required this.timeStampUtc,
    required this.sensors,
    required this.headerEMKey,
    required this.sensorsEMKey,
    required this.scrollController,
  }) : super(key: key);

  final Sensors info;
  final bool testMode;
  final String timeDownload, timeStampUtc;
  final List<SensorType> sensors;
  final GlobalKey headerEMKey, sensorsEMKey;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StationName(info: info),
        const Spacer(),
        IconButton(
            splashColor: kSplashColor,
            onPressed: () async {
              if (!testMode) {
                await sendUTCDate(context);
              } else {
                snackBar(context, 'TEST - Envio de TimeStamp',
                    const Duration(milliseconds: kDurationSnackBar));
              }
            },
            icon: Image.asset(
              reloadClockIcon,
              color: Colors.white,
            )),
        const SizedBox(width: 5),
        IconButton(
          splashColor: kSplashColor,
          onPressed: () async {
            // Pedir permiso para almacenamiento
            bool granted = await requestStoragePermission();
            if (!granted) {
              snackBar(context, 'Permiso de almacenamiento denegado',
                  const Duration(seconds: 2));
              return;
            }

            snackBar(context, 'Comenzando captura...',
                const Duration(milliseconds: kDurationSnackBar + 1000));
            WidgetShotRenderRepaintBoundary headerBoundary =
            headerEMKey.currentContext!.findRenderObject()
            as WidgetShotRenderRepaintBoundary;

            /*if (headerBoundary.debugNeedsPaint) {
              await Future.delayed(const Duration(milliseconds: 1000));
            }*/
            var headerImage = await headerBoundary.screenshot(
                backgroundColor: Colors.black,
                format: ShotFormat.png,
                pixelRatio: 1);

            /* if (headerBoundary.debugNeedsPaint) {
              await Future.delayed(const Duration(milliseconds: 1000));
            }*/
            WidgetShotRenderRepaintBoundary sensorsBoundary =
            sensorsEMKey.currentContext!.findRenderObject()
            as WidgetShotRenderRepaintBoundary;
            /*if (sensorsBoundary.debugNeedsPaint) {
              await Future.delayed(const Duration(milliseconds: 1000));
            }*/
            var resultImage = await sensorsBoundary.screenshot(
              backgroundColor: Colors.black,
              format: ShotFormat.png,
              scrollController: scrollController,
              extraImage: [
                if (headerImage != null)
                  ImageParam.start(
                      headerImage, headerEMKey.currentContext!.size!)
              ],
              pixelRatio: 1,
            );
            String? file = await writeScreenshotFile('EM${info.em}_sensors.jpg', resultImage!);
            snackBar(context, file!,
                const Duration(milliseconds: kDurationSnackBar + 1000));
          },
          icon: Image.asset(
            screenShotLogo,
            fit: BoxFit.fitHeight,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

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
      margin: EdgeInsets.only(bottom: 10.sp),
      alignment: Alignment.centerLeft,
      width: double.infinity,
      child: Row(
        children: [
          if (icon != '') Image.asset(icon, color: color, height: 28.sp),
          if (icon != '') SizedBox(width: 12.sp),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                  text: title,
                  style: TextStyle(fontSize: kFontSize.sp, color: color)),
              TextSpan(
                  text: value,
                  style: TextStyle(
                      fontSize: (kFontSize - 2.5).sp,
                      color: color,
                      fontWeight: FontWeight.bold)),
            ]),
          )
        ],
      ),
    );
  }
}

Future<Response<dynamic>> sendUTCDate(BuildContext context) async {
  DateTime actualTimeUTC = DateTime.now().toUtc().add(const Duration(hours: 3));
  final url = Uri.http(urlBase, 'setDateTime.html', {
    'dia': actualTimeUTC.day.toString(),
    'mes': actualTimeUTC.month.toString(),
    'anio': (actualTimeUTC.year - 2000).toString(),
    'hs': actualTimeUTC.hour.toString(),
    'min': actualTimeUTC.minute.toString(),
    'seg': actualTimeUTC.second.toString(),
  });
  debugPrint('Send UTC: ${actualTimeUTC.toString()}\n, $url');

  final dio = Dio();
  final response = await dio.get(url.toString());
  if (response.statusCode == 200) {
    snackBar(context, 'Envio de TimeStamp',
        const Duration(milliseconds: kDurationSnackBar));
  }
  return response;
}

class GlassmorphismContainer extends StatelessWidget {
  const GlassmorphismContainer({
    super.key,
    this.width = double.infinity,
    this.height = double.infinity,
    required this.widget,
  });

  final double width;
  final double height;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.white.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: widget,
                    )))));
  }
}

class CustomPageView extends StatelessWidget {
  const CustomPageView({
    super.key,
    required this.widthScreen,
    required PageController pageController,
  }) : _pageController = pageController;

  final double widthScreen;
  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: 50,
      width: widthScreen * 0.4 - 2 * kDotHeight,
      bottom: 20,
      child: GlassmorphismContainer(
          widget: SmoothPageIndicator(
            controller: _pageController,
            count: kPageCount,
            effect: const ScaleEffect(
              spacing: 18,
              scale: 1.5,
              dotHeight: kDotHeight,
              dotWidth: kDotHeight,
              activeDotColor: Colors.yellowAccent,
            ),
          )),
    );
  }
}