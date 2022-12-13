import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/models/model_sensors.dart';
import 'package:tmra/pages/info_page/info_page.dart';
import 'package:tmra/provider/sensors_provider.dart';

import '../../services/services_sensors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sensorsProvider = Provider.of<SensorsProvider>(context);
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          sensorsProvider.getSensorsInfo();
        },
      ),
      body: FutureBuilder(
        future: sensorsProvider.getSensorsInfo(),
        builder: (BuildContext context, AsyncSnapshot<Sensors> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          Sensors info = snapshot.data!;
          print(info.channels.length);
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopAppBar(info: info),
                Divider(
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                CustomRichText(
                    title: 'Channel Used [0]: ',
                    value: info.channelUsed[0],
                    size: kFontSize),
                CustomRichText(
                    title: 'Channel Used [1]: ',
                    value: info.channelUsed[1],
                    size: kFontSize),
                CustomRichText(
                    title: 'Batería: ',
                    value: '${info.tensionDeBateria}V',
                    size: kFontSize),
                CustomRichText(
                    title: 'Último valor grabado: ',
                    value: info.logLastAddress,
                    size: kFontSize),
                CustomRichText(
                    title: 'Time Stamp: ',
                    value: info.timeStampUtc,
                    size: kFontSize),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                      itemCount: info.channels.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Canal: ${info.channels[index].ch}',
                              style: const TextStyle(fontSize: kFontSize),
                            ),
                            CustomRichText(
                                title: '${info.channels[index].nombre} :',
                                value: info.channels[index].valor,
                                size: kFontSize - 5),
                          ],
                        );
                      }),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class TopAppBar extends StatelessWidget {
  const TopAppBar({
    Key? key,
    required this.info,
  }) : super(key: key);

  final Sensors info;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Estación ${info.em}',
            style: const TextStyle(color: Colors.white, fontSize: kFontSize)),
        const Spacer(),
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: InfoBoards(info: info),
                    inheritTheme: true,
                    ctx: context),
              );
            },
            icon: Image.asset(
              'lib/assets/icons/information.png',
              color: Colors.white,
            )),
        IconButton(
            onPressed: () {},
            icon: Image.asset(
              'lib/assets/icons/save.png',
              color: Colors.white,
            )),
      ],
    );
  }
}

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    Key? key,
    required this.title,
    required this.value,
    this.size = kFontSize,
  }) : super(key: key);

  final String title;
  final String value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: title, style: TextStyle(color: Colors.white, fontSize: size)),
      TextSpan(
          text: value,
          style: TextStyle(
              color: Colors.white,
              fontSize: size,
              fontWeight: FontWeight.bold)),
      const WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: SizedBox(height: 30)),
    ]));
  }
}
