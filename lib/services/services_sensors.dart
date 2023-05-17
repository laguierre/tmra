import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:tmra/models/model_sensors.dart';
import '../constants.dart';

class SensorsTMRAServices {
  Future<Sensors> getSensorsValues(bool testMode) async {
    Sensors info = Sensors();

    ///Datos en duro
    if (testMode) {
      final String response =
          await rootBundle.loadString('lib/assets/json/2v1.json');
      final decodedData = await json.decode(response);
      info = Sensors.fromJson(decodedData);
    }
    ///Datos desde request
    else {
      final url = Uri.http(urlBase, 'resumenJSON.html');
      try {
        var response = await Dio().get(url.toString(),
            options: Options(
                sendTimeout: const Duration(seconds: 20),
                responseType: ResponseType.plain));
        //print(response.statusCode);
        if (response.statusCode == 200) {
          response.headers.value("application/json");
          var decodedData = await json.decode(response.data);
          info = Sensors.fromJson(decodedData);
          //print(info.timeStampUtc);
          //print(response);
        }
      } catch (e) {
        debugPrint('Error ->: $e');
      }
    }
    return info;
  }
}
