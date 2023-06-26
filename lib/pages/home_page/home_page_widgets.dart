import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/pages/widgets.dart';
import 'package:widget_screenshot/widget_screenshot.dart';
import '../../models/model_sensors.dart';
import '../../models/sensors_type.dart';
import '../snackbar.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({Key? key, required this.info, required this.index})
      : super(key: key);
  final SensorType info;
  final int index;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double ratio = 0.32;

    double dg =
        sqrt((widthScreen * widthScreen) + (heightScreen * heightScreen));
    //debugPrint('->>>>Screen Diagonal: $dg');
    double height = dg < 780 ? 0.10 * dg * info.lines : 0.079 * dg * info.lines;
    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 150,
            maxWidth: MediaQuery.of(context).size.width * ratio,
            minWidth: MediaQuery.of(context).size.width * ratio,
          ),
          child: _ImageSensor(
            info: info,
            height: 0.17 * dg,
            //width: width,
          ),
        ),
        ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 100,
              maxHeight: height,
              maxWidth:
                  MediaQuery.of(context).size.width * (1 - ratio) - kPadding,
              minWidth:
                  MediaQuery.of(context).size.width * (1 - ratio) - kPadding,
            ),
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  top: heightScreen * 0.025,
                  left: widthScreen * 0.04,
                  right: widthScreen * 0.04,
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 5,
                      blurRadius: 13,
                      offset: const Offset(1, 5), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25 * dg * 0.001),
                      bottomLeft: Radius.circular(25 * dg * 0.001),
                      topRight: Radius.circular(25 * dg * 0.001),
                      bottomRight: Radius.circular(25 * dg * 0.001)),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: info.variableName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AutoSizeText.rich(
                      textScaleFactor: 1.0,
                      TextSpan(
                          text: '${info.variableName[index]} ',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          children: [
                            TextSpan(
                                text: '\n${info.variableValue[index]}\n',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ]),
                      minFontSize: 18,
                      stepGranularity: 0.1,
                    );
                  },
                ))),
      ],
    ); //_WithStack(info: info, height: height, width: width);
  }
}

class _ImageSensor extends StatelessWidget {
  const _ImageSensor({
    required this.info,
    required this.height,
    // required this.width,
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
        AutoSizeText(
          info.sensorName,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: info.fontSize),
          minFontSize: 16,
          maxFontSize: 20,
          stepGranularity: 0.1,
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
    var size = MediaQuery.of(context).size;
    double dg = sqrt((size.width * size.width) + (size.height * size.height));
    double kCaptureScreenshot = dg < 780 ? 5 : 8;
    return Row(
      children: [
        StationName(info: info),
        const Spacer(),
        IconButton(
            splashColor: kSplashColor,
            onPressed: () async {
              ///Example: http://192.168.4.1/setDateTime.html?dia=9&mes=3&anio=23&hs=12&min=56&seg=40
              ///         http://192.168.4.1/setDateTime.html?dia=13&mes=3&anio=23&hs=18&min=22&seg=44
              if (!testMode) {
                Response<dynamic> response = await sendUTCDate(context);
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
              double k = (info.channels!.length / kCaptureScreenshot);
              snackBar(context, 'Comenzando captura...',
                  const Duration(milliseconds: kDurationSnackBar + 1000));

              var headerBoundary = headerEMKey.currentContext!
                  .findRenderObject() as WidgetShotRenderRepaintBoundary;
              var headerImage = await headerBoundary.screenshot(
                  backgroundColor: Colors.black,
                  format: ShotFormat.png,
                  pixelRatio: 1);

              // ignore: use_build_context_synchronously
              var sensorsBoundary = sensorsEMKey.currentContext!
                  .findRenderObject() as WidgetShotRenderRepaintBoundary;
              var resultImage = await sensorsBoundary.screenshot(
                  backgroundColor: Colors.black,
                  format: ShotFormat.png,
                  scrollController: scrollController,
                  extraImage: [
                    if (headerImage != null)
                      ImageParam.start(
                          headerImage, headerEMKey.currentContext!.size!)
                  ],
                  pixelRatio: 1);

              writeScreenshotFile('EM${info.em}', resultImage!);
              snackBar(context, 'Captura guardada',
                  const Duration(milliseconds: kDurationSnackBar + 1000));
            },
            icon: Image.asset(
              screenShotLogo,
              fit: BoxFit.fitHeight,
              color: Colors.white,
            )),
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
              //maxLines: 2,
              minFontSize: size,
              maxFontSize: size + 1,
              stepGranularity: 0.1,
            ),
          )
        ],
      ),
    );
  }
}

Future<Response<dynamic>> sendUTCDate(BuildContext context) async {
  DateTime actualTimeUTC = DateTime.now().add(const Duration(hours: 3));
  final url = Uri.http(urlBase, 'setDateTime.html', {
    'dia': actualTimeUTC.day.toString(),
    'mes': actualTimeUTC.month.toString(),
    'anio': (actualTimeUTC.year.toInt() - 2000).toString(),
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
