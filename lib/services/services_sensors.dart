import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:tmra/models/model_sensors.dart';
import '../constants.dart';

class SensorsTMRAServices {
  Future<Sensors> getSensorsValues() async {
    Sensors info = Sensors();
    final url = Uri.http(urlBase, 'resumenJSON.html');
    try {
      var response =
          await Dio().get(url.toString(), options: Options(sendTimeout: 20000,  responseType: ResponseType.plain));
      print(response.statusCode);
      if (response.statusCode == 200) {
        response.headers.value("application/json");
        var decodedData = await json.decode(response.data);

        info = Sensors.fromJson(decodedData);
        print(info.timeStampUtc);
        //print(response);
      }
    } catch (e) {
      print('Error ->: $e');
    }

    ///Datos duros
    /*final String response = await rootBundle.loadString('lib/assets/json/sensor.json');
    final decodedData = await json.decode(response);

    info = Sensors.fromJson(decodedData);*/
    return info;
  }
}
