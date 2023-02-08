import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tmra/constants.dart';
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
  static var httpClient = HttpClient();

  @override
  void initState() {
    infTextEditingController = TextEditingController(text: '0');
    supTextEditingController =
        TextEditingController(text: widget.info.logLastAddress);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    infTextEditingController.dispose();
    supTextEditingController.dispose();
  }

  void downloadFile(String url) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
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
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(15)),
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: IconButton(
                      onPressed: () async {
                        Map<Permission, PermissionStatus> statuses = await [
                          Permission.storage,
                          //Permission.manageExternalStorage,
                          //add more permission to request here.
                        ].request();
                        if (statuses[Permission.storage]!.isGranted) {
                          print('Acceso garantizado');
                        }
                        try {
                          var dir = await getApplicationDocumentsDirectory();
                          print(dir.absolute);
                          print(await dir.exists());

                          final queryParameters = {
                            'inf': '0',
                            'sup': '100',
                          };
                          final url = Uri.http(
                              urlBase, 'download.html\?inf=0\&sup=1000');
                          Uri.http(urlBase, 'download.html');

                          var response = await Dio().download(
                              'http://192.168.4.1/download.html?inf=10&sup=300',
                              '${dir.path}/1.raw',
                              //queryParameters: queryParameters,
                              options: Options(
                                  receiveTimeout: 10000,
                                  headers: {
                                    HttpHeaders.acceptEncodingHeader: '*',
                                    HttpHeaders.connectionHeader: 'keep-alive',
                                    //HttpHeaders.contentTypeHeader:                                       'application/octet-stream',

                                  },
                                  responseType: ResponseType.bytes,
                                  followRedirects: false,
                                  validateStatus: (status) {
                                    return status! < 500;
                                  }), onReceiveProgress: (rec, total) {
                            if (total != -1) {
                              print(
                                  "${(rec / total * 100).toStringAsFixed(0)}%");
                              //you can build progressbar feature too
                            }
                            setState(() {});
                          });

                          print(response.data);
                        } on DioError catch (e) {
                          if (e.type == DioErrorType.connectTimeout) {
                            debugPrint('Error Connect Timeout');
                          }
                          if (e.type == DioErrorType.receiveTimeout) {
                            debugPrint('Error Receive Timeout');
                          }
                          print('Error ---->>> $e.message');
                        }
                      },
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('lib/assets/icons/save.png',
                              color: Colors.black),
                          const SizedBox(width: 10),
                          const Text('Guardar',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))
                        ],
                      )),
                ),
              ],
            )
          ],
        ),
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
