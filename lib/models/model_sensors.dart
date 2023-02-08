class Sensors {
  String? em;
  String? logLastAddress;
  String? timeStampUtc;
  String? tensionDeBateria;
  List<String>? cpu;
  List<String>? daq;
  List<String>? wifi;
  List<String>? channelUsed;
  List<Channels>? channels;

  Sensors(
      {this.em,
      this.cpu,
      this.daq,
      this.wifi,
      this.channelUsed,
      this.logLastAddress,
      this.timeStampUtc,
      this.tensionDeBateria,
      this.channels});

  Sensors.fromJson(Map<String, dynamic> json) {
    em = json['EM'];
    cpu = json['CPU'].cast<String>();
    daq = json['DAQ'].cast<String>();
    wifi = json['WIFI'].cast<String>();
    channelUsed = json['channelUsed'].cast<String>();
    logLastAddress = json['LogLastAddress'];
    timeStampUtc = json['TimeStamp (UTC)'];
    tensionDeBateria = json['Tension de bateria']?? "0.0V";
   //if (json['channels'] != null)
    {
      channels = <Channels>[];
      json['channels'].forEach((v) {
        channels!.add(Channels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EM'] = em;
    data['CPU'] = cpu;
    data['DAQ'] = daq;
    data['WIFI'] = wifi;
    data['channelUsed'] = channelUsed;
    data['LogLastAddress'] = logLastAddress;
    data['TimeStamp (UTC)'] = timeStampUtc;
    data['Tension de bateria'] = tensionDeBateria;
    if (channels != null) {
      data['channels'] = channels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Channels {
  String? ch;
  String? nombre;
  String? valor;

  Channels({this.ch, this.nombre, this.valor});

  Channels.fromJson(Map<String, dynamic> json) {
    ch = json['ch'];
    nombre = json['nombre'];
    valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ch'] = ch;
    data['nombre'] = nombre;
    data['valor'] = valor;
    return data;
  }
}
