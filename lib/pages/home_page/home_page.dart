import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tmra/constants.dart';
import 'package:tmra/models/model_sensors.dart';
import 'package:tmra/models/sensors_type.dart';
import 'package:tmra/pages/download_page/download_page.dart';
import 'package:tmra/pages/info_page/info_page.dart';
import 'package:tmra/services/services_sensors.dart';

import 'home_page_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.wifiName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
  final String wifiName;
}

class _HomePageState extends State<HomePage> {
  List<SensorType> sensors = [];
  Sensors info = Sensors();
  var services = SensorsTMRAServices();

  void getSensorInfo() async {
    info = await services.getSensorsValues();
    sensors = fillSensor(info);
    setState(() {});
  }

  @override
  void initState() {
    getSensorInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        body: RefreshIndicator(
            strokeWidth: 2,
            displacement: MediaQuery.of(context).size.height / 2 - 200,
            color: Colors.white,
            onRefresh: () async {
              getSensorInfo();
              //Future<void>.delayed(const Duration(seconds: 3));
            },
            child: sensors.isNotEmpty
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            kPadding, 50, kPadding, kPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TopAppBar(info: info),
                            const Divider(
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
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
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
                            physics: const BouncingScrollPhysics(),
                            itemCount: sensors.length, //info.channels!.length,
                            itemBuilder: (context, index) {
                              return SensorCard(
                                  info: sensors[index], index: index);
                            }),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Espere...',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                        SizedBox(height: 20),
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )));
  }

  List<SensorType> fillSensor(Sensors info) {
    List<SensorType> sensors = [];
    late SensorType sensorType = SensorType();
    for (int i = 0; i < info.channels!.length; i++) {
      switch (info.channels![i].ch) {
        case '0':
          sensorType.sensorName = 'PMB25';
          sensorType.imageSensor = sensorsImagesList[0];
          sensorType.variableName.add('Precipación acumulada');
          sensorType.variableValue.add('${info.channels![i].valor!} mm');
          break;
        case '1':
          sensorType.variableName.add('Intensidad precipitación');
          sensorType.variableValue.add('${info.channels![i].valor!} mm/h');
          sensors.add(sensorType);
          break;
        case '2':
          sensorType = SensorType();
          sensorType.sensorName = 'TR525';
          sensorType.imageSensor = sensorsImagesList[1];
          sensorType.variableName.add('Precipación acumulada');
          sensorType.variableValue.add('${info.channels![i].valor!} mm');
          sensors.add(sensorType);
          break;
        case '3':
          sensorType = SensorType();
          sensorType.sensorName = 'Windsonic\n2D';
          sensorType.imageSensor = sensorsImagesList[2];
          sensorType.variableName.add('Dirección del viento');
          sensorType.variableValue.add('${info.channels![i].valor!}°');
          //sensorType.fontSize = 18;
          break;
        case '4':
          sensorType.variableName.add('Intensidad del viento');
          sensorType.variableValue.add('${info.channels![i].valor!} m/s');
          sensors.add(sensorType);
          break;
        case '5':
          sensorType = SensorType();
          sensorType.sensorName = 'CS215';
          sensorType.imageSensor = sensorsImagesList[3];
          sensorType.variableName.add('Temperatura del aire');
          sensorType.variableValue.add('${info.channels![i].valor!}°C');
          break;
        case '6':
          sensorType.variableName.add('Humedad del aire');
          sensorType.variableValue.add('${info.channels![i].valor!}%');
          sensors.add(sensorType);
          break;
        case '7':
          sensorType = SensorType();
          sensorType.sensorName = 'CS100';
          sensorType.imageSensor = sensorsImagesList[4];
          sensorType.variableName.add('Presión atmosférica');
          sensorType.variableValue.add('${info.channels![i].valor!} hPa');
          sensors.add(sensorType);
          break;
        case '8':
          sensorType = SensorType();
          sensorType.sensorName = 'CS451';
          sensorType.imageSensor = sensorsImagesList[5];
          sensorType.variableName.add('Nivel freático | Altura del arroyo');
          sensorType.variableValue.add('${info.channels![i].valor!} mbns|mts');
          sensorType.lines = 2.3;

          break;
        case '9':
          sensorType.variableName.add('Temperatura del agua');
          sensorType.variableValue.add('${info.channels![i].valor!}°C');
          sensors.add(sensorType);
          break;
        case '10':
          sensorType = SensorType();
          sensorType.sensorName = 'SR50';
          sensorType.imageSensor = sensorsImagesList[6];
          sensorType.variableName.add('Nivel de agua');
          sensorType.variableValue.add(info.channels![i].valor!);
          sensors.add(sensorType);
          break;
        case '11':
          sensorType = SensorType();
          sensorType.sensorName = 'CNR4';
          sensorType.imageSensor = sensorsImagesList[7];
          sensorType.variableName.add('Piranómetro Sup. SW');
          sensorType.variableValue.add('${info.channels![i].valor!} W/m2');
          break;
        case '12':
          sensorType.variableName.add('Piranómetro Inf. SW');
          sensorType.variableValue.add('${info.channels![i].valor!} W/m2');
          break;
        case '13':
          sensorType.variableName.add('Piranómetro Sup. LW');
          sensorType.variableValue.add('${info.channels![i].valor!} W/m2');
          break;
        case '14':
          sensorType.variableName.add('Piranómetro Inf. LW');
          sensorType.variableValue.add('${info.channels![i].valor!} W/m2');
          break;
        case '15':
          sensorType.variableName.add('Termistor');
          sensorType.variableValue.add('${info.channels![i].valor!}°C');
          sensorType.lines = 4.5;
          sensors.add(sensorType);
          break;
        case '16':
          sensorType = SensorType();
          sensorType.sensorName = 'CMP3';
          sensorType.imageSensor = sensorsImagesList[8];
          sensorType.variableName.add('Piranómetro');
          sensorType.variableValue.add('${info.channels![i].valor!} W/m2');
          sensors.add(sensorType);
          break;
        case '17':
          sensorType = SensorType();
          sensorType.sensorName = 'CS655\nSup.';
          sensorType.imageSensor = sensorsImagesList[9];
          sensorType.variableName.add('Permitividad: ');
          sensorType.variableValue.add(info.channels![i].valor!);
          break;
        case '18':
          sensorType.variableName.add('Cont. volumétrico: ');
          sensorType.variableValue.add('${info.channels![i].valor!} m3/m3');
          break;
        case '19':
          sensorType.variableName.add('Conductividad: ');
          sensorType.variableValue.add('${info.channels![i].valor!} dS/m');
          break;
        case '20':
          sensorType.variableName.add('Temp. suelo: ');
          sensorType.variableValue.add('${info.channels![i].valor!}°C');
          sensorType.lines = 3.7;
          sensors.add(sensorType);
          break;
        case '21':
          sensorType = SensorType();
          sensorType.sensorName = 'SNR-NI';
          sensorType.imageSensor = sensorsImagesList[10];
          sensorType.variableName.add('Incidente NI (NI): ');
          sensorType.variableValue.add('${info.channels![i].valor!} W/m2');
          break;
        case '22':
          sensorType.variableName.add('Incidente RED (NI): ');
          sensorType.variableValue.add('${info.channels![i].valor!} W/m2');
          sensors.add(sensorType);
          break;
        case '23':
          sensorType = SensorType();
          sensorType.sensorName = 'SNR-NR';
          sensorType.imageSensor = sensorsImagesList[10];
          sensorType.variableName.add('Incidente NIR (NR): ');
          sensorType.variableValue.add('${info.channels![i].valor!} W/m2');
          break;
        case '24':
          sensorType.variableName.add('Incidente RED (NR): ');
          sensorType.variableValue.add('${info.channels![i].valor!} W/m2');
          sensors.add(sensorType);
          break;
        case '25':
          sensorType = SensorType();
          sensorType.sensorName = 'HFP01';
          sensorType.imageSensor = sensorsImagesList[11];
          sensorType.variableName.add('Flujo de calor suelo: ');
          sensorType.variableValue.add('${info.channels![i].valor!} W/m2');
          sensors.add(sensorType);
          break;
        case '26':
          sensorType = SensorType();
          sensorType.sensorName = 'SI-111';
          sensorType.imageSensor = sensorsImagesList[12];
          sensorType.variableName.add('Temp. de superficie: ');
          sensorType.variableValue.add('${info.channels![i].valor!}°C');
          break;
        case '27':
          sensorType.variableName.add('Temp. del cuerpo: ');
          sensorType.variableValue.add('${info.channels![i].valor!}°C');
          sensors.add(sensorType);
          break;
        case '28':
          sensorType = SensorType();
          sensorType.sensorName = 'CS655\nInf.';
          sensorType.imageSensor = sensorsImagesList[9];
          sensorType.variableName.add('Permitividad: ');
          sensorType.variableValue.add(info.channels![i].valor!);
          break;
        case '29':
          sensorType.variableName.add('Cont. volumetrico: ');
          sensorType.variableValue.add('${info.channels![i].valor!} m3/m3');
          break;
        case '30':
          sensorType.variableName.add('Conductividad: ');
          sensorType.variableValue.add('${info.channels![i].valor!} dS/m');
          break;
        case '31':
          sensorType.variableName.add('Temp. suelo: ');
          sensorType.variableValue.add('${info.channels![i].valor!}°C');
          sensorType.lines = 3.7;
          sensors.add(sensorType);
          break;
        case '32':
          sensorType = SensorType();
          sensorType.sensorName = '034B';
          sensorType.imageSensor = sensorsImagesList[13];
          sensorType.variableName.add('Dirección del viento: ');
          sensorType.variableValue.add('${info.channels![i].valor!}°');
          break;
        case '33':
          sensorType.variableName.add('Velocidad del viento: ');
          sensorType.variableValue.add('${info.channels![i].valor!} s/m');
          sensors.add(sensorType);
          break;
        case '34':
          sensorType = SensorType();
          sensorType.sensorName = 'CSIM11';
          sensorType.imageSensor = sensorsImagesList[14];
          sensorType.variableName.add('ORP: ');
          sensorType.variableValue.add('${info.channels![i].valor!} mV');
          break;
        case '35':
          sensorType.variableName.add('PH: ');
          sensorType.variableValue.add(info.channels![i].valor!);
          sensors.add(sensorType);
          break;
      }
    }
    return sensors;
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
                fontSize: kFontSize + 4,
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
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: DownloadPage(info: info),
                    inheritTheme: true,
                    ctx: context),
              );
            },
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
width: double.infinity,
      height: 40,
      child: Row(
        children: [
          if (icon != '') Image.asset(icon, color: color, height: 30),
          if (icon != '') const SizedBox(width: 15),
          AutoSizeText.rich(
            TextSpan(children: [
              TextSpan(text: title, style: TextStyle(color: color)),
              TextSpan(
                  text: value,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ]),
            minFontSize: size - 1,
            maxFontSize: size,
            stepGranularity: 0.1,
          )
        ],
      ),
    );
  }
}
