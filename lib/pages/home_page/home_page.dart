import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/models/model_sensors.dart';
import 'package:tmra/models/sensors_type.dart';
import 'package:tmra/pages/info_page/info_page.dart';
import 'package:tmra/provider/sensors_provider.dart';
import 'package:tmra/services/services_sensors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SensorType> sensors = [];
  var services = SensorsTMRAServices();

  @override
  Widget build(BuildContext context) {
    services.getSensorsValues();
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          services.getSensorsValues();
        },
      ),
      body: FutureBuilder(
        future: services.getSensorsValues(),
        builder: (BuildContext context, AsyncSnapshot<Sensors> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          Sensors info = snapshot.data!;
          fillSensor(info);
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopAppBar(info: info),
                const Divider(
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                InfoConfig(
                  title: 'Channel Used [0]: ',
                  value: info.channelUsed![0],
                  size: kFontSize,
                  icon: settingsIcon,
                ),
                InfoConfig(
                  title: 'Channel Used [1]: ',
                  value: info.channelUsed![1],
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
                    value: info.logLastAddress!,
                    size: kFontSize,
                    icon: cpuIcon),
                InfoConfig(
                    title: 'Time Stamp: ',
                    value: info.timeStampUtc!,
                    size: kFontSize,
                    icon: clockIcon),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: sensors.length, //info.channels!.length,
                      itemBuilder: (context, index) {
                        return SensorCard(info: sensors[index], index: index);
                      }),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void fillSensor(Sensors info) {
    late SensorType sensorType = SensorType();
    sensors = [];
    for (var sensor in info.channels!) {
      switch (sensor.ch) {
        case '0':
          sensorType.sensorName = 'PMB25';
          sensorType.imageSensor = sensorsImagesList[0];
          sensorType.variableName.add('Precipación acumulada');
          sensorType.variableValue.add('${info.channels![0].valor!} mm');
          break;
        case '1':
          sensorType.variableName.add('Intensidad precipitación');
          sensorType.variableValue.add(info.channels![1].valor!);
          sensors.add(sensorType);
          break;
        case '2':
          sensorType = SensorType();
          sensorType.sensorName = 'TR525';
          sensorType.imageSensor = sensorsImagesList[1];
          sensorType.variableName.add('Precipación acumulada');
          sensorType.variableValue.add(info.channels![2].valor!);
          sensors.add(sensorType);
          break;
        case '3':
          sensorType = SensorType();
          sensorType.sensorName = 'Windsonic\n2D';
          sensorType.imageSensor = sensorsImagesList[2];
          sensorType.variableName.add('Dirección del viento');
          sensorType.variableValue.add(info.channels![3].valor!);
          break;
        case '4':
          sensorType.variableName.add('Intensidad del viento');
          sensorType.variableValue.add(info.channels![4].valor!);
          sensors.add(sensorType);
          break;
        case '5':
          sensorType = SensorType();
          sensorType.sensorName = 'CS215';
          sensorType.imageSensor = sensorsImagesList[3];
          sensorType.variableName.add('Temperatura del aire');
          sensorType.variableValue.add(info.channels![5].valor!);
          break;
        case '6':
          sensorType.variableName.add('Humedad del aire');
          sensorType.variableValue.add(info.channels![6].valor!);
          sensors.add(sensorType);
          break;
        case '7':
          sensorType = SensorType();
          sensorType.sensorName = 'CS100';
          sensorType.imageSensor = sensorsImagesList[4];
          sensorType.variableName.add('Presión atmosférica');
          sensorType.variableValue.add(info.channels![7].valor!);
          sensors.add(sensorType);
          break;

        case '8':
          sensorType = SensorType();
          sensorType.sensorName = 'CS451';
          sensorType.imageSensor = sensorsImagesList[5];
          sensorType.variableName.add('Nivel freático | Altura del arroyo');
          sensorType.variableValue.add(info.channels![8].valor!);
          break;
        case '9':
          sensorType.variableName.add('Temperatura del agua');
          sensorType.variableValue.add(info.channels![9].valor!);
          sensors.add(sensorType);
          break;
        case '10':
          sensorType = SensorType();
          sensorType.sensorName = 'SR50';
          sensorType.imageSensor = sensorsImagesList[6];
          sensorType.variableName.add('Nivel de agua');
          sensorType.variableValue.add(info.channels![10].valor!);
          sensors.add(sensorType);
          break;
        case '11':
          sensorType = SensorType();
          sensorType.sensorName = 'CNR4';
          sensorType.imageSensor = sensorsImagesList[7];
          sensorType.variableName.add('Piranómetro Sup. SW');
          sensorType.variableValue.add(info.channels![11].valor!);
          break;
        case '12':
          sensorType.variableName.add('Piranómetro Inf. SW');
          sensorType.variableValue.add(info.channels![12].valor!);
          break;
        case '13':
          sensorType.variableName.add('Piranómetro Sup. LW');
          sensorType.variableValue.add(info.channels![13].valor!);
          break;
        case '14':
          sensorType.variableName.add('Piranómetro Inf. LW');
          sensorType.variableValue.add(info.channels![14].valor!);
          break;
        case '15':
          sensorType.variableName.add('Termistor');
          sensorType.variableValue.add(info.channels![15].valor!);
          sensors.add(sensorType);
          break;
        case '16':
          sensorType = SensorType();
          sensorType.sensorName = 'CMP3';
          sensorType.imageSensor = sensorsImagesList[8];
          sensorType.variableName.add('Piranómetro');
          sensorType.variableValue.add(info.channels![16].valor!);
          sensors.add(sensorType);
          break;
        case '17':
          sensorType = SensorType();
          sensorType.sensorName = 'CS655\nSup.';
          sensorType.imageSensor = sensorsImagesList[9];
          sensorType.variableName.add('Permitividad: ');
          sensorType.variableValue.add(info.channels![17].valor!);
          break;
        case '18':
          sensorType.variableName.add('Cont. volumétrico: ');
          sensorType.variableValue.add(info.channels![18].valor!);
          break;
        case '19':
          sensorType.variableName.add('Conductividad: ');
          sensorType.variableValue.add(info.channels![19].valor!);
          break;
        case '20':
          sensorType.variableName.add('Temp. suelo: ');
          sensorType.variableValue.add(info.channels![20].valor!);
          sensors.add(sensorType);
          break;
        case '21':
          sensorType = SensorType();
          sensorType.sensorName = 'SNR-NIR';
          sensorType.imageSensor = sensorsImagesList[10];
          sensorType.variableName.add('Incidente NIR (SNR): ');
          sensorType.variableValue.add(info.channels![21].valor!);
          break;
        case '22':
          sensorType.variableName.add('Incidente RED (SNR): ');
          sensorType.variableValue.add(info.channels![22].valor!);
          sensors.add(sensorType);
          break;
        case '23':
          sensorType = SensorType();
          sensorType.sensorName = 'SNR-NIR';
          sensorType.imageSensor = sensorsImagesList[10];
          sensorType.variableName.add('Incidente NIR (SNR): ');
          sensorType.variableValue.add(info.channels![23].valor!);
          break;
        case '24':
          sensorType.variableName.add('Incidente RED (SNR): ');
          sensorType.variableValue.add(info.channels![24].valor!);
          sensors.add(sensorType);
          break;
        case '25':
          sensorType = SensorType();
          sensorType.sensorName = 'HFP01';
          sensorType.imageSensor = sensorsImagesList[11];
          sensorType.variableName.add('Flujo de calor suelo: ');
          sensorType.variableValue.add(info.channels![25].valor!);
          sensors.add(sensorType);
          break;
        case '26':
          sensorType = SensorType();
          sensorType.sensorName = 'SI-111';
          sensorType.imageSensor = sensorsImagesList[12];
          sensorType.variableName.add('Temp. de superficie: ');
          sensorType.variableValue.add(info.channels![26].valor!);
          break;
        case '27':
          sensorType.variableName.add('Temp. del cuerpo: ');
          sensorType.variableValue.add(info.channels![27].valor!);
          sensors.add(sensorType);
          break;
        case '28':
          sensorType = SensorType();
          sensorType.sensorName = 'CS655\nInf.';
          sensorType.imageSensor = sensorsImagesList[9];
          sensorType.variableName.add('Permitividad: ');
          sensorType.variableValue.add(info.channels![28].valor!);
          break;
        case '29':
          sensorType.variableName.add('Cont. volumetrico: ');
          sensorType.variableValue.add(info.channels![29].valor!);
          break;
        case '30':
          sensorType.variableName.add('Conductividad: ');
          sensorType.variableValue.add(info.channels![30].valor!);
          break;
        case '31':
          sensorType.variableName.add('Temp. suelo: ');
          sensorType.variableValue.add(info.channels![31].valor!);
          sensors.add(sensorType);
          break;
        case '32':
          sensorType = SensorType();
          sensorType.sensorName = '034B';
          sensorType.imageSensor = sensorsImagesList[13];
          sensorType.variableName.add('Dirección del viento: ');
          sensorType.variableValue.add(info.channels![32].valor!);
          break;
        case '33':
          sensorType.variableName.add('Velocidad del viento: ');
          sensorType.variableValue.add(info.channels![33].valor!);
          sensors.add(sensorType);
          break;
        case '34':
          sensorType = SensorType();
          sensorType.sensorName = 'CSIM11';
          sensorType.imageSensor = sensorsImagesList[14];
          sensorType.variableName.add('ORP: ');
          sensorType.variableValue.add(info.channels![34].valor!);
          break;
        case '35':
          sensorType.variableName.add('PH: ');
          sensorType.variableValue.add(info.channels![35].valor!);
          sensors.add(sensorType);
          break;
      }
    }
  }
}

class SensorCard extends StatelessWidget {
  const SensorCard({Key? key, required this.info, required this.index})
      : super(key: key);
  final SensorType info;
  final int index;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.20;
    double width = MediaQuery.of(context).size.width * 0.2;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 20, left: 97),
          //padding: EdgeInsets.only(top: 10, bottom: 10),
          height: height * 0.9,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: height * (0.4 - 0.38),
            ),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                bottomLeft: Radius.circular(40),
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(0)),
            color: Colors.white,
          ),
        ),
        Positioned(
            left: 0,
            top: 10,
            child: Image.asset(info.imageSensor,
                height: height * 0.7, width: width, fit: BoxFit.contain)),
        Positioned(
            left: 0,
            bottom: 30,
            child: Text(
              info.sensorName,
              textAlign: TextAlign.center,

              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            )),
        Positioned(
            left: 120,
            top: 0,
            right: 0,
            bottom: 0,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: info.variableName.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(
                  '${info.variableName[index]}: ${info.variableValue[index]}',
                  style: const TextStyle(

                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                );
              },
            )),
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
        const SizedBox(width: 10),
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
      height: 40,
      child: Row(
        children: [
          if (icon != '') Image.asset(icon, color: color, height: 30),
          if (icon != '') const SizedBox(width: 15),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: title, style: TextStyle(color: color, fontSize: size)),
            TextSpan(
                text: value,
                style: TextStyle(
                    color: color, fontSize: size, fontWeight: FontWeight.bold)),
          ]))
        ],
      ),
    );
  }
}
