import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:tmra/models/model_sensors.dart';

import '../constants.dart';
import 'package:http/http.dart' as http;

class SensorsTMRAServices {
  Future<Sensors> getSensorsValues() async {
    Sensors info = Sensors();
    final url = Uri.http(urlBase, 'resumenJSON.html', {});

    final response = await http.get(url);
    if (response.statusCode == 200)
    {
      final decodedData = await json.decode(response.body);
      info =  Sensors.fromJson(decodedData);
      print(response.body);
    }
    ///Datos duros
    /*final String response = await rootBundle.loadString('lib/assets/json/allsensors.json');
    final decodedData = await json.decode(response);

    info = Sensors.fromJson(decodedData);*/
    print('aca');
    print(info.channels![2].valor);
    return info;
  }
}
