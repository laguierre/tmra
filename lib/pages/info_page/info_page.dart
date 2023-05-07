import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/models/model_sensors.dart';

import 'info_page_widgets.dart';

class InfoBoards extends StatelessWidget {
  const InfoBoards({
    Key? key,
    required this.info,
  }) : super(key: key);

  final Sensors info;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    ScreenshotController screenshotController = ScreenshotController();
    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Screenshot(
                controller: screenshotController,
                child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        bottom: kPaddingBottomScrollViews),
                    physics: const BouncingScrollPhysics(),
                    child: EMInfo(
                        info: info,
                        screenshotController: screenshotController,
                        size: size)))));
  }
}
