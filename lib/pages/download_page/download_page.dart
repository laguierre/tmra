import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tmra/common.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/pages/snackbar.dart';
import 'package:widget_screenshot/widget_screenshot.dart';
import '../../models/model_sensors.dart';
import '../widgets.dart';
import '../home_page/fill_sensors.dart';
import 'download_page_widgets.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({
    Key? key,
    required this.info,
    required this.testMode,
  }) : super(key: key);

  final Sensors info;
  final bool testMode;

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  late TextEditingController infTextEditingController;
  late TextEditingController supTextEditingController;
  double receivedDataPercent = 0.0;
  int receivedData = 0, totalData = 0;
  bool isDownload = false;
  String? downloadsDirectoryPath;
  String fileName = '';
  bool isSharing = false;
  late String timeStamp, timeDownload;
  GlobalKey downloadEMKey = GlobalKey();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    infTextEditingController =
        TextEditingController(text: widget.info.downloadLastAddress);
    supTextEditingController =
        TextEditingController(text: widget.info.logLastAddress);
    timeStamp = subtractUTC(widget.info.timeStampUtc!, 3);
    timeDownload = subtractUTC(widget.info.timeDownloadUtc!, 3);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    infTextEditingController.dispose();
    supTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late String? file;
    return Scaffold(
        extendBody: false,
        backgroundColor: Colors.black,
        body: WidgetShot(
          key: downloadEMKey,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: SizedBox(
                            height: 40.sp,
                            child: Row(
                              children: [
                                StationName(info: widget.info),
                                const Spacer(),
                                IconButton(
                                    splashColor: kSplashColor,
                                    onPressed: () async {
                                      WidgetShotRenderRepaintBoundary
                                      sensorsBoundary = downloadEMKey
                                          .currentContext!
                                          .findRenderObject()
                                      as WidgetShotRenderRepaintBoundary;
                                      var resultImage =
                                      await sensorsBoundary.screenshot(
                                          backgroundColor: Colors.black,
                                          format: ShotFormat.png,
                                          scrollController: scrollController,
                                          pixelRatio: 1);
                                      file = await writeScreenshotFile(
                                          'EM${widget.info.em}_download', resultImage!);
                                      snackBar(
                                          context,
                                          'Captura guardada en $file',
                                          const Duration(
                                              milliseconds:
                                              kDurationSnackBar + 1000));
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
                      SizedBox(height: 30.sp),
                      Text(
                        'Índice límite INFERIOR',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp
                        ),
                      ),
                      SizedBox(height: 15.sp),
                      CustomFieldText(
                          textEditingController: infTextEditingController),
                      const SizedBox(height: 15),
                      Text(
                        'Índice límite SUPERIOR',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                          //fontSize: kFontSize,
                        ),
                      ),
                      SizedBox(height: 15.sp),
                      CustomFieldText(
                          textEditingController: supTextEditingController),
                      SizedBox(height: 15.sp),
                      InfoLine(text: 'Última fecha: ', boldText: timeDownload),
                      SizedBox(height: 7.sp),
                      InfoLine(
                          text: 'Último índice bajado: ',
                          boldText: widget.info.downloadLastAddress!),
                      SizedBox(height: 7.sp),
                      InfoLine(
                          text: 'Último índice grabado: ',
                          boldText: widget.info.logLastAddress!),
                      SizedBox(height: 45.sp),
                      downloadButtons(context, widget.info.wifi![0]),
                      SizedBox(height: 40.sp),
                      SizedBox(
                        height: 40.sp,
                        child: Row(children: [
                          const Spacer(),
                          CustomIconButton(
                              icon: sharingIcon,
                              onPressed: () {
                                openDialogSharingFile(context, '.raw',
                                    'Archivos descargados [raw]');
                              }),
                          SizedBox(width: 20.sp),
                          CustomIconButton(
                              icon: sharingScreenShotIcon,
                              onPressed: () {
                                openDialogSharingFile(
                                    context, '.jpg', 'Capturas de pantalla');
                              }),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      isDownload
                          ? ProgressBar(
                          receivedDataPercent: receivedDataPercent,
                          receivedData: receivedData,
                          totalData: totalData)
                          : Container(),
                    ],
                  ))),
        ));
  }

  Row downloadButtons(BuildContext context, String wifiSw) {
    double version = double.parse(wifiSw.substring(0, 3));
    debugPrint(version.toString());

    return Row(
      children: [
        version < 2.4 ? const Spacer() : Container(),
        CustomButton(
          icon: webIcon,
          text: 'En Browser',
          kPadding: version < 2.4 ? 0 : 15,
          function: () {
            setState(() {
              isDownload = false;
            });
            InAppBrowser.openWithSystemBrowser(
                url: WebUri('http://192.168.4.1/confDownload.html'));
          },
        ),
        if (version >= 2.4) const SizedBox(width: 30),
        if (version >= 2.4)
          CustomButton(
              icon: 'lib/assets/icons/save.png',
              text: 'Bajar archivo',
              function: () async {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                if (int.parse(supTextEditingController.text) >
                    int.parse(infTextEditingController.text)) {
                  if (!widget.testMode) {
                    await downloadFile(context);
                  } else {
                    fileName =
                    'EM${widget.info.em!.toUpperCase()}_${DateFormat('yyyyMMdd').format(DateTime.now())}_${infTextEditingController.text}_${supTextEditingController.text}.raw';
                    snackBar(context, 'Archivo simulado!!! ($fileName)',
                        const Duration(milliseconds: kDurationSnackBar + 1000));
                    infTextEditingController.text =
                        supTextEditingController.text;
                    timeDownload = DateFormat('dd/MM/yyyy HH:MM:ss')
                        .format(DateTime.now());
                    setState(() {});
                  }
                } else {
                  snackBar(context, 'Límite INFERIOR es mayor a SUPERIOR',
                      const Duration(milliseconds: kDurationSnackBar));
                }
              })
      ],
    );
  }

  Future<void> downloadFile(BuildContext context) async {
    isDownload = true;

    ///Ver aca
    var hasStoragePermission = await Permission.manageExternalStorage.isGranted;
    if (!hasStoragePermission) {
      await Permission.manageExternalStorage.request().isGranted;
      debugPrint('Has Permission');
    } else {
      debugPrint('Has not Permission!!!');
    }

    //var dir = await getApplicationDocumentsDirectory();
    downloadsDirectoryPath = (await DownloadsPath.downloadsDirectory())?.path;
    //print('DownloadsPath: $downloadsDirectoryPath');
    String address =
        'http://192.168.4.1/downloadFile.html?inf=${infTextEditingController.text}&sup=${supTextEditingController.text}';

    fileName =
    'EM${widget.info.em!.toUpperCase()}_${DateFormat('yyyyMMdd').format(DateTime.now())}_${infTextEditingController.text}_${supTextEditingController.text}.raw';

    final Dio dio = Dio();
    await dio.download(
      address,
      '$downloadsDirectoryPath/$fileName',
      onReceiveProgress: (received, total) async {
        debugPrint('Recibido: $received, Total: $total');
        setState(() {
          receivedDataPercent = received / total;
          receivedData = received;
          totalData = total;
        });
        if (total != -1) {
          debugPrint("${(receivedDataPercent * 100).toStringAsFixed(0)}%");
        }
        if (received / total == 1) {
          Future.delayed(const Duration(seconds: 1), () async {
            debugPrint('Archivo guardado $downloadsDirectoryPath');
            snackBar(context, 'Archivo guardado $downloadsDirectoryPath',
                const Duration(milliseconds: kDurationSnackBar));
            setState(() {
              isSharing = true;
            });
          });
        }
      },
    );
  }

  Future<void> checkPermission() async {
    var hasStoragePermission = await Permission.storage.isGranted;
    if (!hasStoragePermission) {
      final status = await Permission.storage.request();
      hasStoragePermission = status.isGranted;
    }
    var dir = await getExternalStorageDirectory();
    if (!Directory("${dir!.path}/RAW").existsSync()) {
      Directory("${dir.path}/RAW").createSync(recursive: true);
    }
  }

  void showAlertDialog(String file, String folder) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Archivo descargado'),
            content: const Text(''),
            actions: [
              ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    openDialogSharingFile(
                        context, '.raw', 'Archivos descargados [raw]');
                  },
                  child: const Text('Abrir en explorador')),
              ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    if (await File(file).exists()) {
                      shareSelectedFile(file);
                    }
                  },
                  child: const Text('Compartir')),
              ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok')),
            ],
          );
        });
  }
}