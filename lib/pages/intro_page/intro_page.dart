import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/pages/home_page/home_page.dart';
import 'package:wifi_iot/wifi_iot.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with WidgetsBindingObserver {
  final info = NetworkInfo();
  String? wifiName = '';
  bool isConnectedESP = false;
  bool isShowNextPage = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _listenForPermissionStatus();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
        wifiName = await info.getWifiName();
        isConnectedESP = wifiName!.contains('EM') || wifiName!.contains('Est') || wifiName!.contains('And');
        setState(() {});
      } else {
        debugPrint('Location Service is not enabled');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TopAppBar(),
            Column(
              children: [
                const SizedBox(height: 50),
                Icon(isConnectedESP ? Icons.wifi_outlined : Icons.wifi_off,
                    color: Colors.white, size: 100),
                const SizedBox(height: 10),
                Text(wifiName!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: kFontSize + 4,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 50),
                !isConnectedESP
                    ? GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 45),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: const Text(
                            'Buscar a una red Estacion xx',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: kFontSize + 1,
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
                      )
                    : Container()
              ],
            ),
            const Spacer(),
            isConnectedESP
                ? Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        child: Image.asset(
                          nextIcon,
                          color: Colors.white,
                          height: 50,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: HomePage(wifiName: wifiName!),
                                inheritTheme: true,
                                ctx: context),
                          );
                        },
                      ),
                      const SizedBox(width: 20)
                    ],
                  )
                : Container(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _TopAppBar extends StatelessWidget {
  const _TopAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Conectarse a una EM',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: kFontSize + 4,
                  fontWeight: FontWeight.bold)),
          Divider(color: Colors.white)
        ]);
  }
}
