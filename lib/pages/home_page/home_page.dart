import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tmra/common.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/models/model_sensors.dart';
import 'package:tmra/models/sensors_type.dart';
import 'package:tmra/pages/download_page/download_page.dart';
import 'package:tmra/pages/home_page/fill_sensors.dart';
import 'package:tmra/services/services_sensors.dart';
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
  ScreenshotController screenshotController = ScreenshotController();

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
                          ? Screenshot(
                              controller: screenshotController,
                              child: EMInfoSensorInfo(
                                  info: info,
                                  testMode: widget.testMode,
                                  screenshotController: screenshotController,
                                  timeDownload: timeDownload,
                                  timeStampUtc: timeStampUtc,
                                  sensors: sensors),
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

class EMInfoSensorInfo extends StatelessWidget {
  const EMInfoSensorInfo({
    super.key,
    required this.info,
    required this.testMode,
    required this.screenshotController,
    required this.timeDownload,
    required this.timeStampUtc,
    required this.sensors,
  });

  final Sensors info;
  final bool testMode;
  final ScreenshotController screenshotController;
  final String timeDownload;
  final String timeStampUtc;
  final List<SensorType> sensors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding:
                const EdgeInsets.fromLTRB(kPadding, 50, kPadding, kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomePageTopAppBar(
                  info: info,
                  testMode: testMode,
                  screenshotController: screenshotController,
                  timeDownload: timeDownload,
                  timeStampUtc: timeStampUtc,
                  sensors: sensors,
                ),
                const Divider(
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
                    value: '${info.downloadLastAdress!} \n[$timeDownload]',
                    size: kFontSize - 1.5,
                    icon: downloadIcon),
                InfoConfig(
                    title: 'Último valor grabado: ',
                    value: info.logLastAddress!,
                    size: kFontSize,
                    icon: cpuIcon),
                InfoConfig(
                    title: 'Time Stamp: ',
                    value: testMode
                        ? DateFormat(
                                'yyyy/MM/dd HH:mm:ss') //TODO chequear el doble espacio acá//
                            .format(DateTime.now())
                        : timeStampUtc, //info.timeStampUtc!,
                    size: kFontSize - 1,
                    icon: clockIcon),
              ],
            )),
        Expanded(
          child: EMSensors(sensors: sensors),
        ),
      ],
    );
  }
}

///Lista de sensores de la EM
class EMSensors extends StatelessWidget {
  const EMSensors({
    super.key,
    required this.sensors,
  });

  final List<SensorType> sensors;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
