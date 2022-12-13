// To parse this JSON data, do
//
//     final sensors = sensorsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Sensors sensorsFromJson(String str) => Sensors.fromJson(json.decode(str));

String sensorsToJson(Sensors data) => json.encode(data.toJson());

class Sensors {
  Sensors({
    required this.em,
    required this.cpu,
    required this.daq,
    required this.wifi,
    required this.channelUsed,
    required this.logLastAddress,
    required this.timeStampUtc,
    required this.tensionDeBateria,
    required this.channels,
  });

  final String em;
  final List<String> cpu;
  final List<String> daq;
  final List<String> wifi;
  final List<String> channelUsed;
  final String logLastAddress;
  final String timeStampUtc;
  final String tensionDeBateria;
  final List<Channel> channels;

  factory Sensors.fromJson(Map<String, dynamic> json) => Sensors(
    em: json["EM"],
    cpu: List<String>.from(json["CPU"].map((x) => x)),
    daq: List<String>.from(json["DAQ"].map((x) => x)),
    wifi: List<String>.from(json["WIFI"].map((x) => x)),
    channelUsed: List<String>.from(json["channelUsed"].map((x) => x)),
    logLastAddress: json["LogLastAddress"],
    timeStampUtc: json["TimeStamp (UTC)"],
    tensionDeBateria: json["Tension de bateria"],
    channels: List<Channel>.from(json["channels"].map((x) => Channel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "EM": em,
    "CPU": List<dynamic>.from(cpu.map((x) => x)),
    "DAQ": List<dynamic>.from(daq.map((x) => x)),
    "WIFI": List<dynamic>.from(wifi.map((x) => x)),
    "channelUsed": List<dynamic>.from(channelUsed.map((x) => x)),
    "LogLastAddress": logLastAddress,
    "TimeStamp (UTC)": timeStampUtc,
    "Tension de bateria": tensionDeBateria,
    "channels": List<dynamic>.from(channels.map((x) => x.toJson())),
  };
}

class Channel {
  Channel({
    required this.ch,
    required this.nombre,
    required this.valor,
  });

  final String ch;
  final String nombre;
  final String valor;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
    ch: json["ch"],
    nombre: json["nombre"],
    valor: json["valor"],
  );

  Map<String, dynamic> toJson() => {
    "ch": ch,
    "nombre": nombre,
    "valor": valor,
  };
}

