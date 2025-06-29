import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tmra/common.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/pages/home_page/home_page.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '../widgets.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with WidgetsBindingObserver {
  final info = NetworkInfo();
  bool isConnectedESP = false;
  bool isShowNextPage = false;
  bool switchSimulation = false;
  Color thumbColor = Colors.black;
  String testMode = 'OFF';
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';

  IconData iconWiFi = Icons.wifi_off;
  String wifiName = 'No hay WiFi Conectada';
  String textWiFi = 'Buscar a una red Estación xx';

  @override
  void initState() {
    super.initState();
    _listenForPermissionStatus();
    WidgetsBinding.instance.addObserver(this);
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      switch (source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          break;
        case ConnectivityResult.wifi:
          iconWiFi = Icons.signal_wifi_connected_no_internet_4;
          wifiName = 'No hay WiFi Conectada';
          textWiFi = 'Buscar a una red Estación xx';
          _listenForPermissionStatus();
          isConnectedESP = false;
          break;
        case ConnectivityResult.none:
        default:
          iconWiFi = Icons.wifi_off;
          wifiName = 'No hay WiFi Conectada';
          textWiFi = 'Habilitar WiFi';
          isConnectedESP = false;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _networkConnectivity.disposeStream();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _listenForPermissionStatus();
    }
  }

  void _listenForPermissionStatus() async {
    PermissionWithService locationPermission = Permission.locationWhenInUse;
    var permissionStatus = await locationPermission.status;
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await locationPermission.request();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await locationPermission.request();
      }
    }
    if (permissionStatus == PermissionStatus.granted) {
      bool isLocationServiceOn =
          await locationPermission.serviceStatus.isEnabled;
      if (isLocationServiceOn) {
        wifiName = (await info.getWifiName()) ?? '';
        if (wifiName.isNotEmpty) {
          debugPrint('Nombre WiFi: $wifiName');
          isConnectedESP = wifiName.contains('EM') ||
              wifiName.contains('Est') ||
              wifiName.contains('And');
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
            child: Container(
                height: size.height,
                width: size.width,
                padding: const EdgeInsets.fromLTRB(15, 50, 15, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const _TopAppBar(),
                    Column(
                      children: [
                        const SizedBox(height: 50),
                        Icon(isConnectedESP ? Icons.wifi_outlined : iconWiFi,
                            color: Colors.white, size: 100),
                        const SizedBox(height: 15),
                        Text(wifiName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: kFontSize + 4,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 50.sp),
                      ],
                    ),
                    Visibility(
                      visible: !isConnectedESP,
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 45),
                          height: 50.sp,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: AutoSizeText(
                            textWiFi,
                            maxLines: 1,
                            maxFontSize: kFontSize + 1,
                            minFontSize: kFontSize - 3,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () async {
                          _listenForPermissionStatus();
                          if (!isConnectedESP) {
                            WiFiForIoTPlugin.setEnabled(false,
                                shouldOpenSettings: true);
                          }
                          setState(() {});
                        },
                      ),
                    ),
                    const Spacer(),
                    debugMode(),
                    SizedBox(height: 50.sp),
                    SizedBox(
                      height: 50.sp,
                      child: Row(
                        children: [
                          SizedBox(width: 10.sp),
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
                          SizedBox(width: 20.sp),
                          Visibility(
                            visible: isConnectedESP && !switchSimulation,
                            child: CustomIconButton(
                              icon: webIcon,
                              onPressed: () {
                                InAppBrowser.openWithSystemBrowser(
                                    url: WebUri('http://192.168.4.1'));
                              },
                            ),
                          ),
                          const Spacer(),
                          Visibility(
                              visible: isConnectedESP || switchSimulation,
                              child: CustomIconButton(
                                icon: nextIcon,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: HomePage(
                                          wifiName: wifiName,
                                          testMode: switchSimulation,
                                        ),
                                        inheritTheme: true,
                                        ctx: context),
                                  );
                                },
                              )),
                          SizedBox(width: 20.sp)
                        ],
                      ),
                    ),
                    SizedBox(height: 10.sp),
                  ],
                ))));
  }

  Row debugMode() {
    return Row(
      children: [
        const SizedBox(width: 20),
        CupertinoSwitch(
            trackColor: Colors.white,
            thumbColor: thumbColor,
            activeColor: Colors.amberAccent,
            value: switchSimulation,
            onChanged: (value) {
              setState(() {
                switchSimulation = value;
                if (value) {
                  thumbColor = Colors.white;
                  testMode = 'ON';
                  switchSimulation = true;
                } else {
                  thumbColor = Colors.black;
                  testMode = 'OFF';
                  switchSimulation = false;
                }
              });
            }),
        const SizedBox(width: 10),
        Text('Modo Test $testMode',
            style: const TextStyle(
                color: Colors.white,
                fontSize: kFontSize,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _TopAppBar extends StatelessWidget {
  const _TopAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Conectarse a una EM',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: kFontSize + 4,
                  fontWeight: FontWeight.bold)),
          Divider(color: Colors.white)
        ]);
  }
}

class NetworkConnectivity {
  NetworkConnectivity._();

  static final _instance = NetworkConnectivity._();

  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController.broadcast();

  Stream get myStream => _controller.stream;

  // void initialise() async {
  //   ConnectivityResult result = await _networkConnectivity.checkConnectivity();
  //   _checkStatus(result);
  //   _networkConnectivity.onConnectivityChanged.listen((result) {
  //     _checkStatus(result);
  //   });
  // }

  void initialise() async {
    List<ConnectivityResult> results = await _networkConnectivity.checkConnectivity();
    for (var result in results) {
      _checkStatus(result);
    }

    _networkConnectivity.onConnectivityChanged.listen((results) {
      for (var result in results) {
        _checkStatus(result);
      }
    });
  }


  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }
  void disposeStream() => _controller.close();
}
