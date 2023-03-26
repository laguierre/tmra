import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tmra/constants.dart';
import '../../models/sensors_type.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({Key? key, required this.info, required this.index})
      : super(key: key);
  final SensorType info;
  final int index;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double ratio = 0.32;

    double dg =
        sqrt((widthScreen * widthScreen) + (heightScreen * heightScreen));
    debugPrint('->>>>Screen Diagonal: $dg');
    double height = dg < 780 ? 0.10 * dg * info.lines : 0.079 * dg * info.lines;
    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 150,
            maxWidth: MediaQuery.of(context).size.width * ratio,
            minWidth: MediaQuery.of(context).size.width * ratio,
          ),
          child: _ImageSensor(
            info: info,
            height: 0.17 * dg,
            //width: width,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 100,
            maxHeight: height,
            maxWidth:
                MediaQuery.of(context).size.width * (1 - ratio) - kPadding,
            minWidth:
                MediaQuery.of(context).size.width * (1 - ratio) - kPadding,
          ),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: heightScreen * 0.025,
              left: widthScreen * 0.04,
              right: widthScreen * 0.04,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 5,
                  blurRadius: 13,
                  offset: const Offset(1, 5), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25 * dg * 0.001),
                  bottomLeft: Radius.circular(25 * dg * 0.001),
                  topRight: Radius.circular(25 * dg * 0.001),
                  bottomRight: Radius.circular(25 * dg * 0.001)),
              color: Colors.white,
            ),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: info.variableName.length,
              itemBuilder: (BuildContext context, int index) {
                return AutoSizeText.rich(
                  textScaleFactor: 1.0,
                  TextSpan(
                      text: '${info.variableName[index]} ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        TextSpan(
                            text: '\n${info.variableValue[index]}\n',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                  minFontSize: 18,
                  stepGranularity: 0.1,
                );
              },
            ),
          ),
        ),
      ],
    ); //_WithStack(info: info, height: height, width: width);
  }
}

class _ImageSensor extends StatelessWidget {
  const _ImageSensor({
    required this.info,
    required this.height,
    // required this.width,
  });

  final SensorType info;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          info.imageSensor,
          height: height * 0.68,
          fit: BoxFit.fitHeight,
        ),
        const SizedBox(height: 10),
        AutoSizeText(
          info.sensorName,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: info.fontSize),
          minFontSize: 16,
          maxFontSize: 20,
          stepGranularity: 0.1,
        ),
      ],
    );
  }
}
