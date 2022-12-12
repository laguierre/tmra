import 'package:flutter/cupertino.dart';
import 'package:tmra/services/services_sensors.dart';

import '../models/model_sensors.dart';

class SensorsProvider extends ChangeNotifier {
  Future<Sensors> getSensorsInfo() async {
    var services = SensorsTMRAServices();
    return await services.getSensorsValues();
  }
}
