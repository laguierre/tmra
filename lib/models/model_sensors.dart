// To parse this JSON data, do
//
//     final sensors = sensorsFromJson(jsonString);
import 'dart:convert';

Sensors sensorsFromJson(String str) => Sensors.fromJson(json.decode(str));

String sensorsToJson(Sensors data) => json.encode(data.toJson());

class Sensors {
  Sensors({
    required this.channelUsed,
    required this.logLastAddress,
    required this.timeStampUtc,
    required this.tensionDeBateria,
    required this.channels,
  });

  final List<String> channelUsed;
  final String logLastAddress;
  final String timeStampUtc;
  final String tensionDeBateria;
  final List<Channel> channels;

  factory Sensors.fromJson(Map<String, dynamic> json) => Sensors(
    channelUsed: List<String>.from(json["channelUsed"].map((x) => x)),
    logLastAddress: json["LogLastAddress"],
    timeStampUtc: json["TimeStamp (UTC)"],
    tensionDeBateria: json["Tension de bateria"],
    channels: List<Channel>.from(json["channels"].map((x) => Channel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
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
