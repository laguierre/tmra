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
                InfoConfig(
                  title: 'Channel Used [0]: ',
                  value: info.channelUsed[0],
                  size: kFontSize,
                  icon: settingsIcon,
                ),
                InfoConfig(
                  title: 'Channel Used [1]: ',
                  value: info.channelUsed[1],
                  size: kFontSize,
                  icon: settingsIcon,
                ),
                InfoConfig(
                  title: 'Batería: ',
                  value: '${info.tensionDeBateria}V',
                  size: kFontSize,
                  icon: batteryIcon,
                ),
                InfoConfig(
                    title: 'Último valor grabado: ',
                    value: info.logLastAddress,
                    size: kFontSize,
                    icon: cpuIcon),
                InfoConfig(
                    title: 'Time Stamp: ',
                    value: info.timeStampUtc,
                    size: kFontSize,
                    icon: clockIcon),
                Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: info.channels.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SensorCard(info: info, index: index),
                            Text(
                              'Canal: ${info.channels[index].ch}',
                              style: const TextStyle(fontSize: kFontSize),
                            ),
                            /* InfoConfig(
                                title: '${info.channels[index].nombre} :',
                                value: info.channels[index].valor,
                                size: kFontSize - 5),*/
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

class SensorCard extends StatelessWidget {
  const SensorCard({Key? key, required this.info, required this.index})
      : super(key: key);
  final Sensors info;
  final int index;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.13;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          margin: EdgeInsets.only(left: 50),
          height: height * 0.8,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: height * (0.5 - 0.48),
            ),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            color: Colors.white,
          ),
        ),
        CircleAvatar(
          radius: height * 0.5,
          backgroundColor: Colors.grey,
          child: CircleAvatar(
            radius: height * 0.48,
            backgroundColor: Colors.white,
            child: Image.asset(sensorsImagesList[1],
                height: height * 0.75, fit: BoxFit.fill),
          ),
        ),
        Positioned(
            child: InfoConfig(
              color: Colors.black,
          title: '${info.channels[index].nombre} :',
          value: info.channels[index].valor,
          size: kFontSize - 5,
          icon: '',
        ))
      ],
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
            style: const TextStyle(
                color: Colors.white,
                fontSize: kFontSize + 8,
                fontWeight: FontWeight.bold)),
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
              infoIcon,
              color: Colors.white,
            )),
        SizedBox(width: 10),
        IconButton(
            onPressed: () {},
            icon: Image.asset(
              saveIcon,
              color: Colors.white,
            )),
      ],
    );
  }
}

class InfoConfig extends StatelessWidget {
  const InfoConfig({
    Key? key,
    required this.title,
    required this.value,
    this.size = kFontSize,
    required this.icon,  this.color = Colors.white,
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
      height: 40,
      child: Row(
        children: [
          if (icon != '') Image.asset(icon, color: color, height: 30),
          if (icon != '') const SizedBox(width: 15),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: title,
                style: TextStyle(color: color, fontSize: size)),
            TextSpan(
                text: value,
                style: TextStyle(
                    color: color,
                    fontSize: size,
                    fontWeight: FontWeight.bold)),
          ]))
        ],
      ),
    );
  }
}
