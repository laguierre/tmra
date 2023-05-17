import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tmra/common.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/models/model_sensors.dart';
import 'package:tmra/models/sensors_type.dart';
import 'package:tmra/pages/download_page/download_page.dart';
import 'package:tmra/pages/home_page/fill_sensors.dart';
import 'package:tmra/services/services_sensors.dart';
import 'package:widget_screenshot/widget_screenshot.dart';
import '../info_page/info_page.dart';
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
  late PageController _pageController;

  ///Para captura de pantalla
  GlobalKey headerEMKey = GlobalKey();
  GlobalKey sensorsEMKey = GlobalKey();
  ScrollController scrollController = ScrollController();

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
    _pageController = PageController(viewportFraction: 1, keepPage: true);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        body: Stack(
          alignment: Alignment.center,
          children: [
            PageView(
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                children: [
                  ///Page 1
                  RefreshIndicator(
                      strokeWidth: 3,
                      displacement:
                          MediaQuery.of(context).size.height / 2 - 200,
                      color: Colors.black,
                      backgroundColor: Colors.white,
                      onRefresh: () async {
                        getSensorInfo();
                      },
                      child: sensors.isNotEmpty
                          ? Column(
                              children: [
                                HeaderInfo(
                                    headerEMKey: headerEMKey,
                                    info: info,
                                    widget: widget,
                                    timeDownload: timeDownload,
                                    timeStampUtc: timeStampUtc,
                                    sensors: sensors,
                                    sensorsEMKey: sensorsEMKey,
                                    scrollController: scrollController),
                                Expanded(
                                  child: WidgetShot(
                                      key: sensorsEMKey,
                                      child: EMSensors(
                                        sensors: sensors,
                                        scrollController: scrollController,
                                      )),
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
                                              color: Colors.white,
                                              fontSize: 18)),
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
                            )),

                  ///Page 2
                  InfoBoards(info: info),

                  ///Page 3
                  DownloadPage(
                    info: info,
                    testMode: widget.testMode,
                  )
                ]),
            if (sensors.isNotEmpty)
              CustomPageView(
                  widthScreen: widthScreen, pageController: _pageController),
          ],
        ));
  }
}

class HeaderInfo extends StatelessWidget {
  const HeaderInfo({
    super.key,
    required this.headerEMKey,
    required this.info,
    required this.widget,
    required this.timeDownload,
    required this.timeStampUtc,
    required this.sensors,
    required this.sensorsEMKey,
    required this.scrollController,
  });

  final GlobalKey<State<StatefulWidget>> headerEMKey;
  final Sensors info;
  final HomePage widget;
  final String timeDownload;
  final String timeStampUtc;
  final List<SensorType> sensors;
  final GlobalKey<State<StatefulWidget>> sensorsEMKey;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return WidgetShot(
      key: headerEMKey,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(kPadding, 50, kPadding, kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomePageTopAppBar(
                info: info,
                testMode: widget.testMode,
                timeDownload: timeDownload,
                timeStampUtc: timeStampUtc,
                sensors: sensors,
                headerEMKey: headerEMKey,
                sensorsEMKey: sensorsEMKey,
                scrollController: scrollController,
              ),
              const Divider(
                height: 10,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              InfoConfig(
                  title: 'Batería: ',
                  value: '${info.tensionDeBateria}V',
                  size: kFontSize,
                  icon: batteryIcon),
              InfoConfig(
                  title: 'Último valor bajado: ',
                  value: '${info.downloadLastAddress!} \n[$timeDownload]',
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
                      ? DateFormat(
                              'yyyy/MM/dd HH:mm:ss') //TODO chequear el doble espacio acá//
                          .format(DateTime.now())
                      : timeStampUtc,
                  //info.timeStampUtc!,
                  size: kFontSize - 1,
                  icon: clockIcon),
            ],
          )),
    );
  }
}

///Lista de sensores de la EM
class EMSensors extends StatelessWidget {
  const EMSensors({
    super.key,
    required this.sensors,
    required this.scrollController,
  });

  final List<SensorType> sensors;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.only(
            top: 0, bottom: kPaddingBottomScrollViews, left: 5, right: 5),
        physics: const BouncingScrollPhysics(),
        itemCount: sensors.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SensorCard(info: sensors[index], index: index),
          );
        });
  }
}
