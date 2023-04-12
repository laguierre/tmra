import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tmra/constants.dart';
import '../../models/model_sensors.dart';
import '../../models/sensors_type.dart';
import '../download_page/download_page.dart';
import '../info_page/info_page.dart';
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

class TopAppBar extends StatelessWidget {
  const TopAppBar({
    Key? key,
    required this.info,
    required this.testMode,
  }) : super(key: key);

  final Sensors info;
  final bool testMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Estación ${info.em}',
            style: const TextStyle(
                color: Colors.white,
                fontSize: kFontSize + 4,
                fontWeight: FontWeight.bold)),
        const Spacer(),
        IconButton(
            onPressed: () async {
              ///Example: http://192.168.4.1/setDateTime.html?dia=9&mes=3&anio=23&hs=12&min=56&seg=40
              ///         http://192.168.4.1/setDateTime.html?dia=13&mes=3&anio=23&hs=18&min=22&seg=44
              if (!testMode) {
                Response<dynamic> response = await sendUTCDate(context);
              } else {
                snackBar(context, 'TEST - Envio de TimeStamp');
              }
            },
            icon: Image.asset(
              reloadClockIcon,
              color: Colors.white,
            )),
        const SizedBox(width: 10),
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: InfoBoards(info: info),
                    inheritTheme: true,
                    ctx: context),
              );
            },
            icon: Image.asset(
              infoIcon,
              color: Colors.white,
            )),
        const SizedBox(width: 10),
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: DownloadPage(info: info, testMode: testMode),
                    inheritTheme: true,
                    ctx: context),
              );
            },
            icon: Image.asset(
              saveIcon,
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
    snackBar(context, 'Envio de TimeStamp');
  }
  return response;
}
