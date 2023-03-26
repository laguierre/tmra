import 'package:flutter/cupertino.dart';
import 'package:tmra/models/sensors_type.dart';
import '../models/model_sensors.dart';

class SensorsProvider extends ChangeNotifier {
  late Sensors _info;
  List<SensorType> sensors = [];

  Sensors get info => _info;

  set info(Sensors info) {
    _info = info;
    notifyListeners();
  }
}
