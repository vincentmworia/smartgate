import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartgate/widgets/gate_is_opened.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/Home Screen';

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final buttonStyle = ElevatedButton.styleFrom(
        minimumSize: Size(shortestSide * 0.3, shortestSide * 0.2));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Elimu'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: buttonStyle,
                          onPressed: () {
                            if (kDebugMode) {
                              print('OPEN GATE PRESSED');
                            }
                            // todo Publish to MQTT broker
                          },
                          child: const Text('OPEN'),
                        ),
                        ElevatedButton(
                          style: buttonStyle,
                          onPressed: () {
                            if (kDebugMode) {
                              print('CLOSE GATE PRESSED');
                            }
                            // todo Publish to MQTT broker
                          },
                          child: const Text('CLOSE'),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        );
      }),
      // appBar: AppBar(),
    );
  }
}
