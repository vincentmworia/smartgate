import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../private_data.dart';
import './login_user_data.dart';

enum ConnectionStatus {
  disconnected,
  connected,
}

class MqttProvider with ChangeNotifier {
  late MqttServerClient _mqttClient;
  Timer? timerGraph;
  Timer? timerDummyData;

  MqttServerClient get mqttClient => _mqttClient;

  String? get disconnectTopic => _devicesClient;

  String get disconnectMessage => "Disconnected-$_loginTime";

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
  String? _deviceId;
  String? _devicesClient;
  String? _loginTime;

  static void removeFirstElement(List list) {
    if (list.length >= (3600 / 2)) {
      list.removeAt(0);
    }
  }

  Future<ConnectionStatus> initializeMqttClient() async {
    _deviceId =
        '&${LoginUserData.getLoggedUser!.email}&${LoginUserData.getLoggedUser!.firstname}&${LoginUserData.getLoggedUser!.lastname}';
    _devicesClient = 'cbes/dekut/devices/$platform/$_deviceId';

    _loginTime = DateTime.now().toIso8601String();
    final connMessage = MqttConnectMessage()
      ..authenticateAs(mqttUsername, mqttPassword)
      ..withWillTopic(_devicesClient!)
      ..withWillMessage('DisconnectedHard-$_loginTime')
      ..withWillRetain()
      ..startClean()
      ..withWillQos(MqttQos.exactlyOnce);

    _mqttClient = MqttServerClient.withPort(
        mqttHost,
        'flutter_client/$_devicesClient/${DateTime.now().toIso8601String()}',
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
    } catch (e) {
      if (kDebugMode) {
        print('\n\nException: $e');
      }

      _mqttClient.disconnect();
      _connStatus = ConnectionStatus.disconnected;
    }

    if (_connStatus == ConnectionStatus.connected) {
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
    publishMsg(_devicesClient!, 'Connected-$_loginTime');
  }

  void onDisconnected() {
    _connStatus = ConnectionStatus.disconnected;
    timerGraph?.cancel();
    timerDummyData?.cancel();
    notifyListeners();
  }
}
