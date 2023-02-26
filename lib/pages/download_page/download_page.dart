import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tmra/constants.dart';
import '../../models/model_sensors.dart';
import '../web_page/web_page.dart';
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
            const _SaveWithLimits(),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(15)),
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: IconButton(
                      onPressed: () async {
                        _OpenWithSystemBrowser();
                      },
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('lib/assets/icons/save.png',
                              color: Colors.black),
                          const SizedBox(width: 10),
                          const Text('En Browser',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))
                        ],
                      )),
                ),
              ],
            ),
            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(15)),
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: IconButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: WebViewPage(),
                              inheritTheme: true,
                              ctx: context),
                        );

                      },
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('lib/assets/icons/save.png',
                              color: Colors.black),
                          const SizedBox(width: 10),
                          const Text('Abrir Web',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))
                        ],
                      )),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(15)),
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: IconButton(
                      onPressed: () async {
                        ///Ver aca
                        /*var hasStoragePermission = await Permission.manageExternalStorage.isGranted;
                        if (!hasStoragePermission) {
                          final status = await Permission.manageExternalStorage.request();
                          hasStoragePermission = status.isGranted;
                          print('Has Permission');
                        }
                        else{
                          print('Has not Permission!!!');
                        }*/
                        var dir = await DownloadsPath.downloadsDirectory();
                        print('Dir: $dir');
                        /*if (!Directory("${dir!.path}").existsSync()) {
                          Directory("${dir.path}").createSync(recursive: true);
                        }*/

                        final Dio _dio = Dio();
                        //var dir = await getApplicationDocumentsDirectory();
                        String? downloadsDirectoryPath =
                            (await DownloadsPath.downloadsDirectory())?.path;
                        print('DownloadsPath: $downloadsDirectoryPath');
                        final response = await _dio.download(
                          //'http://192.168.4.1/download.html?inf=0&sup=0',
                          'http://192.168.4.1/downloadFile.html',
                          //'${dir.path}/raw/test.raw',
                          '$downloadsDirectoryPath/11.raw',
                          onReceiveProgress: (received, total) async {
                            if (total != -1) {
                              print(
                                  (received / total * 100).toStringAsFixed(0) +
                                      "%");
                              showAlertDialog('$downloadsDirectoryPath/11.raw',
                                  '$downloadsDirectoryPath');
                              print('Archivo guardado $downloadsDirectoryPath');
                            }
                          },
                        );
                      },
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('lib/assets/icons/save.png',
                              color: Colors.black),
                          const SizedBox(width: 10),
                          const Text('downloadFile',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))
                        ],
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _OpenWithSystemBrowser() {
    InAppBrowser.openWithSystemBrowser(
        url: Uri.parse('http://192.168.4.1/confDownload.html'));
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
                    var rootPath = await DownloadsPath.downloadsDirectory();
                    print('Folder: $rootPath');
                    if (await File(file).exists()) {
                      String? path = await FilesystemPicker.openDialog(
                        fileTileSelectMode: FileTileSelectMode.wholeTile,
                        title: 'Archivo',
                        context: context,
                        rootDirectory: rootPath!,
                        fsType: FilesystemType.file,
                        pickText: 'Save file to this folder',
                        folderIconColor: Colors.black,
                        allowedExtensions: ['.raw'],
                      );
                      print('Picker: $path');
                      if (path!.isNotEmpty) {
                        Share.shareXFiles([XFile(path)],
                            text: 'Archivo descargado');
                      }
                    }
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

class _SaveWithLimits extends StatelessWidget {
  const _SaveWithLimits({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.yellowAccent,
              borderRadius: BorderRadius.circular(15)),
          width: MediaQuery.of(context).size.width * 0.5,
          child: IconButton(
              onPressed: () async {
                var dir =  await DownloadsPath.downloadsDirectory();
                print(dir);

                var request = await HttpClient()
                    .getUrl(
                      Uri.parse(
                          //'http://192.168.4.1/download.html?inf=0&sup=300'),
                          'http://192.168.4.1/downloadFile.html'),
                    ) // produces a request object
                    .then((request) => request.close()) // sends the request
                    .then((response) => response
                        .transform(Utf8Decoder())
                        .listen(print)); // transforms and prints the response
                var response = await request.cancel();
                //var response = request.close();
                // print(response.toString());
              }
              /* var response = await Dio(BaseOptions(
                          receiveDataWhenStatusError: true,
                          connectTimeout: 60 * 1000, // 60 seconds
                          receiveTimeout: 60 * 1000 // 60 seconds
                          ))
                      .download(
                          'http://192.168.4.1/download.html?inf=0&sup=300',
                          '${dir.path}/1.raw',
                          //queryParameters: queryParameters,

                          options: Options(

                              //receiveTimeout: 10000,
                              headers: {
                                //HttpHeaders.acceptCharsetHeader: 'UTF-8',
                                //HttpHeaders.acceptEncodingHeader: '*',

                                HttpHeaders.connectionHeader:
                                    'keep-alive',
                                //HttpHeaders.contentTypeHeader:                                       'application/octet-stream',
                              },
                              //responseType: ResponseType.plain,
                              //followRedirects: false,
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

                  print(response.statusCode);
                } on DioError catch (e) {
                  if (e.type == DioErrorType.connectTimeout) {
                    debugPrint('Error Connect Timeout');
                  }
                  if (e.type == DioErrorType.receiveTimeout) {
                    debugPrint('Error Receive Timeout');
                  }
                  print('Error ---->>> $e.message');*/

              ,
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/icons/save.png', color: Colors.black),
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
