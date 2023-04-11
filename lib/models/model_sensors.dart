class Sensors {
  String? em;
  String? downloadLastAdress;
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
      this.downloadLastAdress,
      this.logLastAddress,
      this.timeStampUtc,
      this.tensionDeBateria,
      this.timeDownloadUtc,
      this.channels});

  Sensors.fromJson(Map<String, dynamic> json) {
    em = json['EM'];
    cpu = json['CPU'].cast<String>();
    daq = json['DAQ'].cast<String>();
    wifi = json['WIFI'].cast<String>();
    channelUsed = json['channelUsed'].cast<String>();
    controlledChannel = json['controlledChannel'].cast<String>() ?? [];
    downloadLastAdress = json['DownloadLastAddress'] ?? '0';
    timeDownloadUtc = json['Download TimeStamp (UTC)'] ?? 'N/A';
    logLastAddress = json['LogLastAddress'];
    timeStampUtc = json['TimeStamp (UTC)'];
    tensionDeBateria = json['Tension de bateria'] ?? "0.0V";
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
