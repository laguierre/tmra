import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/models/model_sensors.dart';
import 'package:tmra/pages/home_page/home_page.dart';
import 'package:tmra/pages/widgets.dart';
import 'package:tmra/provider/sensors_provider.dart';

class InfoBoards extends StatelessWidget {
  const InfoBoards({
    Key? key, required this.info,
  }) : super(key: key);

  final Sensors info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopAppBarBack(info: info),
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const InfoConfig(
                      title: '',
                      value: 'WiFi Board Info',
                      icon: wifiIcon,
                    ),
                    InfoConfig(
                        icon: '',
                        title: 'Sw version: ',
                        value: info.wifi![0],
                        size: kFontSize - 4),
                    InfoConfig(
                        icon: '',
                        title: 'Hw version: ',
                        value: info.wifi![1],
                        size: kFontSize - 4),

                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const InfoConfig(
                        icon: cpuIcon, title: '', value: 'CPU Board Info'),
                    InfoConfig(
                        icon: '',
                        title: 'Sw version: ',
                        value: info.cpu![0],
                        size: kFontSize - 4),
                    InfoConfig(
                        icon: '',
                        title: 'Hw version: ',
                        value: info.cpu![1],
                        size: kFontSize - 4),
                    InfoConfig(
                      title: 'Channel Used [0]: ',
                      value: info.channelUsed![0],
                      size: kFontSize - 4,
                      icon: "",
                    ),
                    InfoConfig(
                      title: 'Channel Used [1]: ',
                      value: info.channelUsed![1],
                      size: kFontSize - 4,
                      icon: "",
                    ),
                    InfoConfig(
                      title: 'Controlled Channel Used [0]: ',
                      value: info.controlledChannel![0],
                      size: kFontSize - 4,
                      icon: "",
                    ),
                    InfoConfig(
                      title: 'Controlled Channel Used [1]: ',
                      value: info.controlledChannel![1],
                      size: kFontSize - 4,
                      icon: "",
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const InfoConfig(title: '', value: 'DAQ Board Info', icon: adcIcon,),
                    InfoConfig(
                      icon: '',
                        title: 'Sw version: ',
                        value: info.daq![0],
                        size: kFontSize - 4),
                    InfoConfig(
                      icon: '',
                        title: 'Hw version: ',
                        value: info.daq![1],
                        size: kFontSize - 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
