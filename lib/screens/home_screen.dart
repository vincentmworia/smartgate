import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/mqtt.dart';
import '../widgets/gate_is_opened.dart';
import '../widgets/iot_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/Home Screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Elimu',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 3.0,
            )),
        centerTitle: true,
        // leading: const Icon(Icons.add),
      ),
      drawer: const Drawer(),
      body: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return SizedBox(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                flex: 2,
                child: Center(
                  // todo Stream from MQTT broker
                  child: GateIsOpened(true),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Consumer<MqttProvider>(
                    builder: (BuildContext context, MqttProvider mqttProvider,
                            Widget? child) =>
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IotButton(
                          width: width,
                          height: height,
                          mqttProvider: mqttProvider,
                          bnTopic: 'smartgate/opengate',
                          title: 'Open',
                        ),
                        IotButton(
                          width: width,
                          height: height,
                          mqttProvider: mqttProvider,
                          bnTopic: 'smartgate/closegate',
                          title: 'Close',
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        );
      }),
      // appBar: AppBar(),
    );
  }
}
