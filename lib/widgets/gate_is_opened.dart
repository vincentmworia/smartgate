import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartgate/providers/mqtt.dart';

class GateIsOpened extends StatefulWidget {
  const GateIsOpened(this.gateOpen, {super.key});

  final bool gateOpen;

  @override
  State<GateIsOpened> createState() => _GateIsOpenedState();
}

class _GateIsOpenedState extends State<GateIsOpened>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 4), vsync: this)
          ..repeat(reverse: true);
    // _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
      opacity: _animation,
      child: Consumer<MqttProvider>(
        builder: (BuildContext context, MqttProvider mqttprov, Widget? child) =>
            Image.asset(
          'images/hgate3${mqttprov.gateStatus ? 2 : 1}.png',
          fit: BoxFit.cover,
        ),
      ));
}
