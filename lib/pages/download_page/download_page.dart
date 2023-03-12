import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tmra/common.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/pages/snackbar.dart';
import '../../models/model_sensors.dart';
import '../widgets.dart';

class DownloadPage extends StatefulWidget {
  DownloadPage({Key? key, required this.info}) : super(key: key);

  final Sensors info;

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

  @override
  void initState() {
    infTextEditingController = TextEditingController(text: '0');
    supTextEditingController =
        TextEditingController(text: widget.info.logLastAddress);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // TODO: implement dispose
    if (infTextEditingController != null) {
      infTextEditingController.dispose();
      supTextEditingController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeButton = 65;
    return Scaffold(
      extendBody: false,
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopAppBarBack(info: widget.info),
              const SizedBox(height: 30),
              const Text(
                'Límite inferior',
                style: TextStyle(color: Colors.white, fontSize: kFontSize),
              ),
              const SizedBox(height: 15),
              CustomFieldText(textEditingController: infTextEditingController),
              const SizedBox(height: 15),
              const Text(
                'Límite superior',
                style: TextStyle(color: Colors.white, fontSize: kFontSize),
              ),
              const SizedBox(height: 15),
              CustomFieldText(textEditingController: supTextEditingController),
              const SizedBox(height: 45),
              Row(
                children: [
                  CustomButton(
                    icon: webIcon,
                    text: 'En Browser',
                    function: () {
                      setState(() {
                        isDownload = false;
                      });
                      InAppBrowser.openWithSystemBrowser(
                          url: Uri.parse(
                              'http://192.168.4.1/confDownload.html'));
                    },
                  ),
                  const SizedBox(width: 30),
                  CustomButton(
                    icon: 'lib/assets/icons/save.png',
                    text: 'Bajar archivo',
                    function: () async {
                      await downloadFile(context);
                    },
                  )
                ],
              ),
              const SizedBox(height: 40),
              Row(children: [
                const Spacer(),
                isSharing? CircleCustomButton(
                  sizeButton: sizeButton,
                  icon: sharingIcon,
                  function: () async {
                    final file =  '$downloadsDirectoryPath/$fileName';
                    if (await File(file).exists()) {
                      Share.shareXFiles([XFile(file)],
                          text: 'Archivo descargado');
                    }

                  },
                ): Container(),
                const SizedBox(width: 20),

                CircleCustomButton(
                  sizeButton: sizeButton,
                  icon: openFolderIcon,
                  function: () {
                    openSharingFile(context);
                  },
                ),

              ]),
              const SizedBox(height: 20),
              isDownload
                  ? ProgressBar(
                      receivedDataPercent: receivedDataPercent,
                      receivedData: receivedData,
                      totalData: totalData)
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> downloadFile(BuildContext context) async {
    isDownload = true;

    ///Ver aca
    var hasStoragePermission = await Permission.manageExternalStorage.isGranted;
    if (!hasStoragePermission) {
      final status = await Permission.manageExternalStorage.request().isGranted;
      print('Has Permission');
    } else {
      print('Has not Permission!!!');
    }
    var dir = await DownloadsPath.downloadsDirectory();
    print('Dir: $dir');

    //var dir = await getApplicationDocumentsDirectory();
    downloadsDirectoryPath = (await DownloadsPath.downloadsDirectory())?.path;
    print('DownloadsPath: $downloadsDirectoryPath');
    String address =
        'http://192.168.4.1/downloadFile.html?inf=${infTextEditingController.text}&sup=${supTextEditingController.text}';

    fileName =
        'EM${widget.info.em!.toUpperCase()}_${DateFormat('yyyyMMdd').format(DateTime.now())}_${infTextEditingController.text}_${supTextEditingController.text}.raw';

    final Dio dio = Dio();
    final response = await dio.download(
      address,
      '$downloadsDirectoryPath/$fileName',
      onReceiveProgress: (received, total) async {
        print('Recibido: ${received}, Total: ${total}');
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
            //isDownload = false;
            /*showAlertDialog(
                '$downloadsDirectoryPath/$fileName', '$downloadsDirectoryPath');*/
            print('Archivo guardado $downloadsDirectoryPath');
            snackBar(context, 'Archivo guardado $downloadsDirectoryPath');
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
                    openSharingFile(context);
                  },
                  child: const Text('Abrir en explorador')),
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    if (await File(file).exists()) {
                      Share.shareXFiles([XFile(file)],
                          text: 'Archivo descargado');
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



class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.receivedDataPercent,
    required this.receivedData,
    required this.totalData,
  });

  final double receivedDataPercent;
  final int receivedData;
  final int totalData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearPercentIndicator(
          padding: const EdgeInsets.all(0),
          animateFromLastPercent: true,
          barRadius: const Radius.circular(20),
          lineHeight: 15,
          percent: receivedDataPercent,
          backgroundColor: Colors.white,
          progressColor: Colors.yellowAccent,
        ),
        const SizedBox(height: 20),
        Text("Porcentaje: ${(receivedDataPercent * 100).toStringAsFixed(1)}%",
            style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text("Recibido: ${receivedData} / Total: ${totalData}",
            style: const TextStyle(fontSize: 18, color: Colors.white)),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.function,
      required this.icon,
      required this.text})
      : super(key: key);

  final VoidCallback function;
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.yellowAccent,
                borderRadius: BorderRadius.circular(15)),
            width: MediaQuery.of(context).size.width * 0.45 - 15,
            child: IconButton(
                onPressed: function,
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(icon, color: Colors.black),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AutoSizeText(text,
                          stepGranularity: 0.1,
                          maxLines: 1,
                          maxFontSize: 24,
                          minFontSize: 16,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class CustomFieldText extends StatelessWidget {
  const CustomFieldText({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        textAlign: TextAlign.right,
        onChanged: (text) {},
        controller: textEditingController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          hintStyle:
              TextStyle(color: Colors.grey, decoration: TextDecoration.none),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          isDense: true,
        ),
        style: const TextStyle(
          fontSize: 26.0,
          decoration: TextDecoration.none,
          color: Colors.black,
        ),
      ),
    );
  }
}
