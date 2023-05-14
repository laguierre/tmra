import 'package:flutter/material.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/models/model_sensors.dart';
import 'package:widget_screenshot/widget_screenshot.dart';

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
    ScrollController scrollController = ScrollController();
    GlobalKey infoKey = GlobalKey();
    return WidgetShot(
      key: infoKey,
      child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.black,
          body: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: SingleChildScrollView(
                controller: scrollController,
                padding:
                    const EdgeInsets.only(bottom: kPaddingBottomScrollViews),
                physics: const BouncingScrollPhysics(),
                child: EMInfo(
                    info: info,
                    size: size,
                    scrollController: scrollController,
                    infoKey: infoKey),
              ))),
    );
  }
}
