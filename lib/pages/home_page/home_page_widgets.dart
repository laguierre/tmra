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
    //double height = MediaQuery.of(context).size.height * info.kFactorContainer;
    double width = MediaQuery.of(context).size.width * 0.2;
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double ratio = 0.32;

    double dg =
        sqrt((widthScreen * widthScreen) + (heightScreen * heightScreen));
    double height = dg < 750 ? 0.10 * dg * info.lines : 0.079 * dg * info.lines;
    print(dg);
    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 100,
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
              top: heightScreen * 0.03,
              left: widthScreen * 0.04,
              right: widthScreen * 0.04,
            ),
            //height: height,
            //width: MediaQuery.of(context).size.width * (1 - ratio) - kPadding,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 7,
                  blurRadius: 13,
                  offset: const Offset(1, 3), // changes position of shadow
                ),
              ],
              /*border: Border.all(
                color: Colors.grey,
                width: height * (0.4 - 0.38),
              ),*/
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
                  TextSpan(
                      text: '${info.variableName[index]} ',
                      style: TextStyle(
                        //fontSize: 0.019 * dg,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        TextSpan(
                            text: '\n${info.variableValue[index]}\n',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                  maxFontSize: 28,
                  minFontSize: 17,
                  stepGranularity: 0.1,
                );
              },
            ),
          ),
        ),
        /*Container(
          margin: const EdgeInsets.only(top: 5, bottom: 15, left: 0, right: 0),
          padding: EdgeInsets.only(
              top: heightScreen * 0.03, left: widthScreen * 0.04),
          height: height,
          width: MediaQuery.of(context).size.width * (1 - ratio) - kPadding,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(1, 3), // changes position of shadow
              ),
            ],
            border: Border.all(
              color: Colors.grey,
              width: height * (0.4 - 0.38),
            ),
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(0),
                bottomLeft: Radius.circular(35 * dg * 0.001),
                topRight: Radius.circular(35 * dg * 0.001),
                bottomRight: const Radius.circular(0)),
            color: Colors.white,
          ),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: info.variableName.length,
            itemBuilder: (BuildContext context, int index) {
              return AutoSizeText.rich(
                TextSpan(
                    text: '${info.variableName[index]} ',
                    style: TextStyle(
                      fontSize: 0.019 * dg,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                    children: [
                      TextSpan(
                          text: '\n${info.variableValue[index]}\n',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                maxFontSize: 24,
                minFontSize: 17,
                stepGranularity: 0.1,
              );
            },
          ),
        ),*/
      ],
    ); //_WithStack(info: info, height: height, width: width);
  }
}

/*
class _WithStack extends StatelessWidget {
  const _WithStack({
    super.key,
    required this.info,
    required this.height,
    required this.width,
  });

  final SensorType info;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        _ImageSensor(
          info: info,
          height: height,
          //width: width,
        ),
        _CardContainer(height: height * 1.01),
        Positioned(
            left: 120,
            top: height * 0.16,
            right: 0,
            bottom: 0,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: info.variableName.length,
              itemBuilder: (BuildContext context, int index) {
                return AutoSizeText.rich(
                  TextSpan(
                      text: '${info.variableName[index]} ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        TextSpan(
                            text: '\n${info.variableValue[index]}\n',
                            style: const TextStyle(fontWeight: FontWeight.bold))
                      ]),
                  maxFontSize: 19,
                  minFontSize: 17,
                  maxLines: 2,
                  stepGranularity: 0.1,
                );
              },
            )),
      ],
    );
  }
}
*/
class _CardContainer extends StatelessWidget {
  const _CardContainer({
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20, left: 97, right: 5),
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(1, 3), // changes position of shadow
          ),
        ],
        border: Border.all(
          color: Colors.grey,
          width: height * (0.4 - 0.38),
        ),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            bottomLeft: Radius.circular(35),
            topRight: Radius.circular(35),
            bottomRight: Radius.circular(0)),
        color: Colors.white,
      ),
    );
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

  //final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          info.imageSensor,
          height: height * 0.68,
          //width: width,
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
/*
class _ImageSensor extends StatelessWidget {
  const _ImageSensor({
    required this.info,
    required this.height,
    required this.width,
  });

  final SensorType info;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        bottom: 0,
        top: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(info.imageSensor,
                height: height * 0.5, width: width, fit: BoxFit.contain),
            const SizedBox(height: 10),
            AutoSizeText(
              info.sensorName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: info.fontSize),
              minFontSize: 17,
              maxFontSize: 22,
              stepGranularity: 0.1,
            ),
          ],
        ));
  }
}
*/
