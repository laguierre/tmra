class Sensors {
  String? em;
  String? downloadLastAddress;
  String? logLastAddress;
  String? timeStampUtc;
  String? timeDownloadUtc;
  String? tensionDeBateria;
  List<String>? cpu;
  List<String>? daq;
  List<String>? wifi;
  List<String>? channelUsed;
  List<String>? controlledChannel;
  List<Channels>? channels;

  Sensors(
      {this.em,
      this.cpu,
      this.daq,
      this.wifi,
      this.channelUsed,
      this.controlledChannel,
      this.downloadLastAddress,
      this.logLastAddress,
      this.timeStampUtc,
      this.tensionDeBateria,
      this.timeDownloadUtc,
      this.channels});

  Sensors.fromJson(Map<String, dynamic> json) {
    em = json['EM'];
    cpu = json['CPU'].cast<String>() ?? [];
    daq = json['DAQ'].cast<String>() ?? [];
    wifi = json['WIFI'].cast<String>() ?? [];
    channelUsed = json['channelUsed'].cast<String>() ?? [];
    controlledChannel = json['controlledChannel'].cast<String>() ?? [];
    downloadLastAddress = json['DownloadLastAddress'] ?? '0';
    timeDownloadUtc =
        json['Download TimeStamp (UTC)'] ?? '24/12/2022  04:40:38';
    logLastAddress = json['LogLastAddress'] ?? '0';
    timeStampUtc = json['TimeStamp (UTC)'] ?? "24/12/2022  04:40:38";
    tensionDeBateria = json['Tension de bateria'] ?? "0.0";
    //if (json['channels'] != null)
    {
      channels = <Channels>[];
      json['channels'].forEach((v) {
        channels!.add(Channels.fromJson(v));
      });
    }
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
}
