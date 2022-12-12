import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/models/model_sensors.dart';
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
                Row(
                  children: [
                    const Text('Estacion',
                        style: TextStyle(color: Colors.white)),
                    const Spacer(),
                    IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'lib/assets/icons/save.png',
                          color: Colors.white,
                        ))
                  ],
                ),
                CustomRichText(
                    title: 'Channel Used [0]: ', value: info.channelUsed[0], size: kFontSize),
                CustomRichText(
                    title: 'Channel Used [1]: ', value: info.channelUsed[1], size: kFontSize),
                CustomRichText(
                    title: 'Batería: ', value: '${info.tensionDeBateria}V', size: kFontSize),
                CustomRichText(
                    title: 'Último valor grabado: ',
                    value: info.logLastAddress, size: kFontSize),
                CustomRichText(
                    title: 'Time Stamp: ',
                    value: info.timeStampUtc, size: kFontSize),
                Expanded(
                  child: ListView.builder(itemCount: info.channels.length, itemBuilder: (context, index){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Canal: ${info.channels[index].ch}', style: TextStyle(fontSize: kFontSize),),
                        CustomRichText(
                            title: '${info.channels[index].nombre} :',
                            value: info.channels[index].valor, size: kFontSize-5),
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

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    Key? key,
    required this.title,
    required this.value, required this.size,
  }) : super(key: key);

  final String title;
  final String value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: title,
          style:  TextStyle(color: Colors.white, fontSize: size)),
      TextSpan(
          text: value,
          style:  TextStyle(
              color: Colors.white, fontSize: size, fontWeight: FontWeight.bold)),
      const WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: SizedBox(height: 30)),
    ]));
  }
}
