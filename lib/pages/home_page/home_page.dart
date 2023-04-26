import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmra/common.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/models/model_sensors.dart';
import 'package:tmra/models/sensors_type.dart';
import 'package:tmra/pages/home_page/fill_sensors.dart';
import 'package:tmra/services/services_sensors.dart';
import 'home_page_widgets.dart';

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
  String timeStampUtc = '';
  String timeDownload = '';

  void getSensorInfo() async {
    info = await services.getSensorsValues(widget.testMode);
    sensors = fillSensor(info);

    ///Quitar UTC (+3 horas)
    timeStampUtc = subtractUTC(info.timeStampUtc!, 3);
    timeDownload = subtractUTC(info.timeDownloadUtc!, 3);
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
                                    '${info.downloadLastAdress!} \n[$timeDownload]',
                                size: kFontSize - 1.5,
                                icon: downloadIcon),
                            InfoConfig(
                                title: 'Último valor grabado: ',
                                value: info.logLastAddress!,
                                size: kFontSize,
                                icon: cpuIcon),
                            InfoConfig(
                                title: 'Time Stamp: ',
                                value: widget.testMode
                                    ? DateFormat('yyyy/MM/dd  HH:mm:ss').format(DateTime.now())
                                    : timeStampUtc, //info.timeStampUtc!,
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
