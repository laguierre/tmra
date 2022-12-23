
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/model_sensors.dart';

class TopAppBarBack extends StatelessWidget {
  const TopAppBarBack({
    Key? key,
    required this.info,
  }) : super(key: key);

  final Sensors info;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
