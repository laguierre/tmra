import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tmra/common.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/models/model_sensors.dart';
import 'package:tmra/models/sensors_type.dart';
import 'package:tmra/pages/download_page/download_page.dart';
import 'package:tmra/pages/home_page/fill_sensors.dart';
import 'package:tmra/pages/home_page/home_page_widgets.dart';
import 'package:tmra/pages/snackbar.dart';
import 'package:tmra/pages/widgets.dart';
import 'package:tmra/services/services_sensors.dart';
import 'package:widget_screenshot/widget_screenshot.dart';
import '../info_page/info_page.dart';

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
                              child: _prueba(),
                            )
                          : Stack(
                              children: [
                                const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
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

  Widget? _prueba() {
    return Column(
      children: [
        Padding(
            padding:
                const EdgeInsets.fromLTRB(kPadding, 50, kPadding, kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40.sp,
                  child: Row(
                    children: [
                      StationName(info: info),
                      const Spacer(),
                      IconButton(
                          splashColor: kSplashColor,
                          onPressed: () async {
                            if (!widget.testMode) {
                              await sendUTCDate(context);
                            } else {
                              snackBar(
                                  context,
                                  'TEST - Envio de TimeStamp',
                                  const Duration(
                                      milliseconds: kDurationSnackBar));
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
                            snackBar(
                                context,
                                'Permiso de almacenamiento denegado',
                                const Duration(seconds: 2));
                            return;
                          }
                          snackBar(
                              context,
                              'Comenzando captura...',
                              const Duration(
                                  milliseconds: kDurationSnackBar + 1000));

                          final image =
                              await screenshotController.captureFromLongWidget(
                                  SizedBox(
                                    width: 1080,
                                    height: 1920,
                                    child:
                                        Material(
                                          child: _prueba(),
                                        ),
                                  ),
                                  delay: const Duration(milliseconds: 10),
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width));

                          showDialog(
                              useSafeArea: false,
                              context: context,
                              builder: (context) {
                                return Scaffold(
                                  appBar: AppBar(
                                    title: Text('Captura'),
                                  ),
                                  body: Center(
                                    child: Image.memory(image!),
                                  ),
                                );
                              });
                          writeScreenshotFile('EM${info.em}', image);
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
                        ),
                      ),
                    ],
                  ),
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
                    size: kFontSize - 1.5,
                    icon: cpuIcon),
                InfoConfig(
                    title: 'Time Stamp: ',
                    value: widget.testMode
                        ? DateFormat('yyyy/MM/dd HH:mm:ss')
                            .format(DateTime.now())
                        : timeStampUtc,
                    //info.timeStampUtc!,
                    size: kFontSize - 1,
                    icon: clockIcon),
              ],
            )),
        Expanded(
          child: ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.only(
                  top: 0,
                  bottom: kPaddingBottomScrollViews,
                  left: 0.sp,
                  right: 0.sp),
              physics: const BouncingScrollPhysics(),
              itemCount: sensors.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SensorCard(info: sensors[index], index: index),
                );
              }),
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

// class HeaderInfo extends StatelessWidget {
//   const HeaderInfo({
//     super.key,
//     required this.headerEMKey,
//     required this.info,
//     required this.widget,
//     required this.timeDownload,
//     required this.timeStampUtc,
//     required this.sensors,
//     required this.sensorsEMKey,
//     required this.scrollController,
//   });
//
//   final GlobalKey<State<StatefulWidget>> headerEMKey;
//   final Sensors info;
//   final HomePage widget;
//   final String timeDownload;
//   final String timeStampUtc;
//   final List<SensorType> sensors;
//   final GlobalKey<State<StatefulWidget>> sensorsEMKey;
//   final ScrollController scrollController;
//
//   @override
//   Widget build(BuildContext context) {
//     return WidgetShot(
//       key: headerEMKey,
//       child: Padding(
//           padding: const EdgeInsets.fromLTRB(kPadding, 50, kPadding, kPadding),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 40.sp,
//                 child: Row(
//                   children: [
//                     StationName(info: info),
//                     const Spacer(),
//                     IconButton(
//                         splashColor: kSplashColor,
//                         onPressed: () async {
//                           if (!widget.testMode) {
//                             await sendUTCDate(context);
//                           } else {
//                             snackBar(context, 'TEST - Envio de TimeStamp', const Duration(milliseconds: kDurationSnackBar));
//                           }
//                         },
//                         icon: Image.asset(
//                           reloadClockIcon,
//                           color: Colors.white,
//                         )),
//                     const SizedBox(width: 5),
//                     IconButton(
//                       splashColor: kSplashColor,
//                       onPressed: () async {
//                         // Pedir permiso para almacenamiento
//                         bool granted = await requestStoragePermission();
//                         if (!granted) {
//                           snackBar(context, 'Permiso de almacenamiento denegado', const Duration(seconds: 2));
//                           return;
//                         }
//
//                         snackBar(context, 'Comenzando captura...', const Duration(milliseconds: kDurationSnackBar + 1000));
//
//                         final image = await screenshotController.capture(
//                           delay: const Duration(milliseconds: 200), // opcional, por si hay animaciones
//                           pixelRatio: 1.5, // o el valor que necesites
//                         );
//
//
//                         showDialog(
//                             useSafeArea: false,
//                             context: context,
//                             builder: (context) {
//                               return Scaffold(
//                                 appBar: AppBar(
//                                   title: Text('Captura'),
//                                 ),
//                                 body: Center(
//                                   child: Image.memory(image!),
//                                 ),
//                               );
//                             });
//                         //writeScreenshotFile('EM${info.em}', resultImage!);
//                         snackBar(context, 'Captura guardada', const Duration(milliseconds: kDurationSnackBar + 1000));
//                       },
//                       icon: Image.asset(
//                         screenShotLogo,
//                         fit: BoxFit.fitHeight,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(
//                 height: 10,
//                 color: Colors.white,
//               ),
//               const SizedBox(height: 10),
//               InfoConfig(
//                   title: 'Batería: ',
//                   value: '${info.tensionDeBateria}V',
//                   size: kFontSize,
//                   icon: batteryIcon),
//               InfoConfig(
//                   title: 'Último valor bajado: ',
//                   value: '${info.downloadLastAddress!} \n[$timeDownload]',
//                   size: kFontSize - 1.5,
//                   icon: downloadIcon),
//               InfoConfig(
//                   title: 'Último valor grabado: ',
//                   value: info.logLastAddress!,
//                   size: kFontSize - 1.5,
//                   icon: cpuIcon),
//               InfoConfig(
//                   title: 'Time Stamp: ',
//                   value: widget.testMode
//                       ? DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now())
//                       : timeStampUtc,
//                   //info.timeStampUtc!,
//                   size: kFontSize - 1,
//                   icon: clockIcon),
//             ],
//           )),
//     );
//   }
// }

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
        padding: EdgeInsets.only(
            top: 0, bottom: kPaddingBottomScrollViews, left: 0.sp, right: 0.sp),
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
