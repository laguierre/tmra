import 'package:flutter/material.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/models/model_sensors.dart';
import 'package:tmra/pages/home_page/home_page.dart';

class InfoBoards extends StatelessWidget {
  const InfoBoards({
    Key? key,
    required this.info,
  }) : super(key: key);
  final Sensors info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset(
                        'lib/assets/icons/back.png',
                        color: Colors.white,
                      )),
                  const SizedBox(width: 10),
                  Text('Estación ${info.em}',
                      style: const TextStyle(
                          color: Colors.white, fontSize: kFontSize + 3)),
                ],
              ),
            ),
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
                  const CustomRichText(title: '', value: 'WiFi Board Info'),
                  CustomRichText(
                      title: 'Sw version: ',
                      value: info.wifi[0],
                      size: kFontSize - 4),
                  CustomRichText(
                      title: 'Hw version: ',
                      value: info.wifi[1],
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
                  const CustomRichText(title: '', value: 'CPU Board Info'),
                  CustomRichText(
                      title: 'Sw version: ',
                      value: info.cpu[0],
                      size: kFontSize - 4),
                  CustomRichText(
                      title: 'Hw version: ',
                      value: info.cpu[1],
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
                  const CustomRichText(title: '', value: 'DAQ Board Info'),
                  CustomRichText(
                      title: 'Sw version: ',
                      value: info.daq[0],
                      size: kFontSize - 4),
                  CustomRichText(
                      title: 'Hw version: ',
                      value: info.daq[1],
                      size: kFontSize - 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
