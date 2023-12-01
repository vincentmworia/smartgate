import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smartgate/models/logged_in_user.dart';

import '../private_data.dart';
import './login_user_data.dart';

enum ConnectionStatus {
  disconnected,
  connected,
}

class MqttProvider with ChangeNotifier {
  late MqttServerClient _mqttClient;

  MqttServerClient get mqttClient => _mqttClient;


  // String get disconnectMessage => "Disconnected-$_loginTime";

  var _connStatus = ConnectionStatus.disconnected;

  ConnectionStatus get connectionStatus => _connStatus;

  final platform = Platform.isAndroid
      ? "Android"
      : Platform.isWindows
          ? "Windows"
          : Platform.isFuchsia
              ? "Fuchsia"
              : Platform.isIOS
                  ? "IOS"
                  : Platform.isLinux
                      ? "Linux"
                      : "Unknown Operating System";


  static void removeFirstElement(List list) {
    if (list.length >= (3600 / 2)) {
      list.removeAt(0);
    }
  }

  Future<ConnectionStatus> initializeMqttClient(LoggedInUser usr) async {
    final connMessage = MqttConnectMessage()
      ..authenticateAs(mqttUsername, mqttPassword)
      ..withWillTopic('will')
      ..withWillMessage('Disconnected')
      // ..withWillRetain()
      ..startClean()
      ..withWillQos(MqttQos.exactlyOnce);

    _mqttClient = MqttServerClient.withPort(
        mqttHost,
        DateTime.now().toIso8601String(),
        mqttPort)
      ..secure = true
      ..securityContext = SecurityContext.defaultContext
      ..keepAlivePeriod = 30
      ..securityContext = SecurityContext.defaultContext
      ..connectionMessage = connMessage
      ..onConnected = onConnected
      ..onDisconnected = onDisconnected;

    try {
      await _mqttClient.connect();
      _mqttClient.subscribe("#", MqttQos.exactlyOnce);
      _mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final topic = c[0].topic;
        var message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        if (kDebugMode) {
          print(message);
        }
        // TODO Split all the notify listeners to different classes
        if (topic == "cbes/dekut/data/electrical_energy") {
          // _electricalEnergy = ElectricalEnergy.fromMap(
          //     json.decode(message) as Map<String, dynamic>);
          notifyListeners();
        }
      });
      // print('done');
    } catch (e) {
      if (kDebugMode) {
        print('\n\nException: $e');
        // todo prevent login and throw error to the UI
      }

      _mqttClient.disconnect();
      _connStatus = ConnectionStatus.disconnected;
    }

    return _connStatus;
  }

  void refresh() {
    notifyListeners();
  }

  void publishMsg(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    if (kDebugMode) {
      print('Publishing message "$message" to topic $topic');
    }
    _mqttClient.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!,
        retain: true);
  }

  void onConnected() {
    _connStatus = ConnectionStatus.connected;
    // publishMsg(_devicesClient!, 'Connected-$_loginTime');
  }

  void onDisconnected() {
    _connStatus = ConnectionStatus.disconnected;
    notifyListeners();
  }
}
