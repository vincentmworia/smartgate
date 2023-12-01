import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartgate/providers/mqtt.dart';

class IotButton extends StatefulWidget {
  const IotButton(
      {super.key,
      required this.width,
      required this.height,
      required this.bnTopic,
      required this.mqttProvider,
      required this.title});

  final String title;
  final double width;
  final double height;
  final String bnTopic;
  final MqttProvider mqttProvider;

  @override
  State<IotButton> createState() => _IotButtonState();
}

class _IotButtonState extends State<IotButton> {
  var pressed = false;
  late ButtonStyle buttonStyle;

  @override
  void initState() {
    super.initState();
    buttonStyle = ElevatedButton.styleFrom(
        fixedSize: Size(widget.width * 0.3, widget.height * 0.15));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: pressed
          ? null
          : () async {
              setState(() {
                pressed = true;
              });
              widget.mqttProvider.publishMsg(widget.bnTopic, 'true');
              await Future.delayed(const Duration(seconds: 1)).then((value) =>
                  widget.mqttProvider.publishMsg(widget.bnTopic, 'false'));
              setState(() {
                pressed = false;
              });
              // todo Publish to MQTT broker
            },
      child: Text(widget.title),
    );
  }
}
