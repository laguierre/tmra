
import 'package:auto_size_text/auto_size_text.dart';
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

/// Crea una linea con un ícono si está presente, un texto en normal y el siguiente el BOLD
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
      margin: const EdgeInsets.only(bottom: 7),
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 40,
      child: Row(
        children: [
          if (icon != '') Image.asset(icon, color: color, height: 30),
          if (icon != '') const SizedBox(width: 12),
          Expanded(
            child: AutoSizeText.rich(
              TextSpan(children: [
                TextSpan(text: title, style: TextStyle(color: color)),
                TextSpan(
                    text: value,
                    style:
                    TextStyle(color: color, fontWeight: FontWeight.bold)),
              ]),
              minFontSize: size,
              maxFontSize: size + 1,
              stepGranularity: 0.1,
            ),
          )
        ],
      ),
    );
  }
}