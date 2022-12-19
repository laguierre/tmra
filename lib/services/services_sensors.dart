import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:tmra/models/model_sensors.dart';

import '../constants.dart';
import 'package:http/http.dart' as http;

class SensorsTMRAServices {
  Future<Sensors> getSensorsValues() async {
    Sensors info = Sensors();
    /*final url = Uri.http(urlBase, 'resumenJSON.html', {});
    final response = await http.get(url);


    if (response.statusCode == 200)
    {
      final decodedData = json.decode(response.body);
      info = Sensors.fromJson(decodedData);
    }*/
    final String response =
    await rootBundle.loadString('lib/assets/json/allsensors.json');
    final decodedData = await json.decode(response);
    print(decodedData);
    info = Sensors.fromJson(decodedData);
    return info;
  }
}
