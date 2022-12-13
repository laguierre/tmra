import 'dart:convert';

import 'package:tmra/models/model_sensors.dart';

import '../constants.dart';
import 'package:http/http.dart' as http;

class SensorsTMRAServices {
  Future<Sensors> getSensorsValues() async {
    final url = Uri.http(urlBase, 'resumenJSON.html', {});
    //print(url);
    final response = await http.get(url);

    Sensors info = Sensors(
        channelUsed: [],
        logLastAddress: "",
        timeStampUtc: "",
        tensionDeBateria: "",
        channels: [],
        em: '',
        cpu: [],
        daq: [],
        wifi: []);
    //print(decodedData);
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      info = Sensors.fromJson(decodedData);
    }
    print(info.channelUsed);
    return info;
  }
}
/*if (response.statusCode == 200) {
      final decoded = await json.decode(response.body);
      Sensors sensors;

      return sensors;
}*/
