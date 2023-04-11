import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tmra/common.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/models/model_sensors.dart';
import 'package:tmra/models/sensors_type.dart';
import 'package:tmra/pages/download_page/download_page.dart';
import 'package:tmra/pages/download_page/fill_sensors.dart';
import 'package:tmra/pages/info_page/info_page.dart';
import 'package:tmra/pages/snackbar.dart';
import 'package:tmra/services/services_sensors.dart';
import 'home_page_widgets.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.wifiName, required this.testMode})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
  final String wifiName;
  final bool testMode;
}

class _HomePageState extends State<HomePage> {
  List<SensorType> sensors = [];
  Sensors info = Sensors();
  var services = SensorsTMRAServices();

  void getSensorInfo() async {
    info = await services.getSensorsValues(widget.testMode);
    sensors = fillSensor(info);
    setState(() {});
  }

  @override
  void initState() {
    getSensorInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    double dg =
        sqrt((widthScreen * widthScreen) + (heightScreen * heightScreen));
    return Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        body: RefreshIndicator(
            strokeWidth: 3,
            displacement: MediaQuery.of(context).size.height / 2 - 200,
            color: Colors.black,
            backgroundColor: Colors.white,
            onRefresh: () async {
              getSensorInfo();
              //Future<void>.delayed(const Duration(seconds: 3));
            },
            child: sensors.isNotEmpty
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            kPadding, 50, kPadding, kPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TopAppBar(info: info, testMode: widget.testMode),
                            const Divider(
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            InfoConfig(
                              title: 'Batería: ',
                              value: '${info.tensionDeBateria}V',
                              size: kFontSize,
                              icon: batteryIcon,
                            ),
                            InfoConfig(
                                title: 'Último valor bajado: ',
                                value:
                                    '${info.downloadLastAdress!} \n[${info.timeDownloadUtc!}]',
                                size: kFontSize-1,
                                icon: downloadIcon),
                            InfoConfig(
                                title: 'Último valor grabado: ',
                                value: info.logLastAddress!,
                                size: kFontSize,
                                icon: cpuIcon),
                            InfoConfig(
                                title: 'Time Stamp: ',
                                value: widget.testMode? DateFormat('yyyy/MM/dd  HH:mm:ss').format(DateTime.now()) : info.timeStampUtc!,
                                size: kFontSize - 1,
                                icon: clockIcon),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.only(
                                top: 0, bottom: 0, left: 5, right: 5),
                            physics: const BouncingScrollPhysics(),
                            itemCount: sensors.length, //info.channels!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: SensorCard(
                                    info: sensors[index], index: index),
                              );
                            }),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Espere...',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            SizedBox(height: 20),
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 40,
                        bottom: 40,
                        child: CircleCustomButton(
                          sizeButton: 70,
                          icon: reloadingIcon,
                          function: () {
                            getSensorInfo();
                          },
                        ),
                      ),
                    ],
                  )));
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
    debugPrint('------>>>>$actualTimeUTC\n, $url');

    final dio = Dio();
    final response = await dio.get(url.toString());
    if (response.statusCode == 200) {
      snackBar(context, 'Envio de TimeStamp');
    }
    return response;
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
              maxFontSize: size+1,
              stepGranularity: 0.1,
            ),
          )
        ],
      ),
    );
  }
}
