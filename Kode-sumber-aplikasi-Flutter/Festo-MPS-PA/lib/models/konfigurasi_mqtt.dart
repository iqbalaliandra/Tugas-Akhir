import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService extends ChangeNotifier {
  late MqttServerClient client;

  late String server, nama;
  late int port;

  List<String> topicsMonitor = [
    'Temperature',
    'Pressure',
    'Level',
    "Flow",
    "Setpoint",
    "Process Variable",
    "Controller Output",
    "KP",
    "KI",
    "KD"
  ];
  List<String> topicsControl = [
    "Setpoint",
    "Process Variable",
    "Controller Output"
  ];
  List<String> topicsTrend = [
    "Setpoint",
    "Process Variable",
    "Controller Output",
    "KP",
    "KI",
    "KD"
  ];
  ValueNotifier<String> dataTemperature = ValueNotifier<String>('None');
  ValueNotifier<String> dataPressure = ValueNotifier<String>('None');
  ValueNotifier<String> dataLevel = ValueNotifier<String>('None');
  ValueNotifier<String> dataFlow = ValueNotifier<String>('None');
  ValueNotifier<String> dataSetpoint = ValueNotifier<String>('None');
  ValueNotifier<String> dataProcess = ValueNotifier<String>('None');
  ValueNotifier<String> dataOutput = ValueNotifier<String>('None');
  double doubleDataSetpoint = 0;
  double doubleDataProcess = 0;
  double doubleDataOutput = 0;
  ValueNotifier<String> kp = ValueNotifier<String>('None');
  ValueNotifier<String> ki = ValueNotifier<String>('None');
  ValueNotifier<String> kd = ValueNotifier<String>('None');

  MQTTService(this.server, this.nama, this.port);

  Future<Object> connect() async {
    client = MqttServerClient.withPort(server, nama, port);

    client.logging(on: true);
    client.keepAlivePeriod = 60;

    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;

    client.setProtocolV311();

    return client;
  }

  void monitor() async {
    try {
      await client.connect();

      for (String topic in topicsMonitor) {
        client.subscribe(topic, MqttQos.atMostOnce);
      }
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final daftarPesan = c[0].payload as MqttPublishMessage;

      final pesan =
          MqttPublishPayload.bytesToStringAsString(daftarPesan.payload.message);

      final String topic = c[0].topic;

      if (topic == "Temperature") {
        dataTemperature.value = double.parse(pesan).toStringAsFixed(2);
      }
      if (topic == "Pressure") {
        dataPressure.value = double.parse(pesan).toStringAsFixed(3);
      }
      if (topic == "Level") {
        dataLevel.value = double.parse(pesan).toStringAsFixed(2);
      }
      if (topic == "Flow") {
        dataFlow.value = double.parse(pesan).toStringAsFixed(2);
      }
      if (topic == "Setpoint") {
        dataSetpoint.value = double.parse(pesan).toStringAsFixed(2);
      }
      if (topic == "Process Variable") {
        dataProcess.value = double.parse(pesan).toStringAsFixed(2);
      }
      if (topic == "Controller Output") {
        dataOutput.value = double.parse(pesan).toStringAsFixed(2);
      }
      if (topic == "KP") {
        kp.value = double.parse(pesan).toStringAsFixed(2);
      }
      if (topic == "KI") {
        ki.value = double.parse(pesan).toStringAsFixed(2);
      }
      if (topic == "KD") {
        kd.value = double.parse(pesan).toStringAsFixed(2);
      }
      notifyListeners();
      print("MQTT_LOGS:: New data arrived");
    });
  }

  void control() async {
    try {
      await client.connect();

      for (String topic in topicsControl) {
        client.subscribe(topic, MqttQos.atMostOnce);
      }
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final daftarPesan = c[0].payload as MqttPublishMessage;

      final pesan =
          MqttPublishPayload.bytesToStringAsString(daftarPesan.payload.message);

      final String topic = c[0].topic;

      if (topic == "Setpoint") {
        dataSetpoint.value = double.parse(pesan).toStringAsFixed(2);
      }
      if (topic == "Process Variable") {
        dataProcess.value = double.parse(pesan).toStringAsFixed(2);
      }
      if (topic == "Controller Output") {
        dataOutput.value = double.parse(pesan).toStringAsFixed(2);
      }
      notifyListeners();
      print("MQTT_LOGS:: New data arrived");
    });
  }

  void trend() async {
    try {
      await client.connect();

      for (String topic in topicsTrend) {
        client.subscribe(topic, MqttQos.atMostOnce);
      }
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final daftarPesan = c[0].payload as MqttPublishMessage;

      final pesan =
          MqttPublishPayload.bytesToStringAsString(daftarPesan.payload.message);

      final String topic = c[0].topic;

      if (topic == "Setpoint") {
        doubleDataSetpoint = double.parse(pesan);
      }
      if (topic == "Process Variable") {
        doubleDataProcess = double.parse(pesan);
      }
      if (topic == "Controller Output") {
        doubleDataOutput = double.parse(pesan);
      }
      if (topic == "KP") {
        kp.value = double.parse(pesan).toStringAsFixed(2);
      }
      if (topic == "KI") {
        ki.value = double.parse(pesan).toStringAsFixed(2);
      }
      if (topic == "KD") {
        kd.value = double.parse(pesan).toStringAsFixed(2);
      }
      notifyListeners();
      print("MQTT_LOGS:: New data arrived");
    });
  }

  void kirimPesan(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    }
  }

  void disconnect() {
    client.disconnect();
  }

  void onConnected() {
    print('MQTT_LOGS:: Connected');
  }

  void onDisconnected() {
    print('MQTT_LOGS:: Disconnected');
  }

  void onSubscribed(String topic) {
    print('MQTT_LOGS:: Subscribed topic: $topic');
  }

  void onSubscribeFail(String topic) {
    print('MQTT_LOGS:: Failed to subscribe $topic');
  }

  void onUnsubscribed(String? topic) {
    print('MQTT_LOGS:: Unsubscribed topic: $topic');
  }

  void pong() {
    print('MQTT_LOGS:: Ping response client callback invoked');
  }
}
