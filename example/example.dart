import 'package:animated_countdown_timer/animated_countdown_timer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CountdownExample(),
    );
  }
}

class CountdownExample extends StatelessWidget {
  const CountdownExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedCountdownTimer(
          initialCount: 5,
          textColor: Colors.yellow,
          overlayColor: Colors.black54,
          onStart: () {
            print("Countdown started!");
          },
          onDone: () {
            print("Countdown finished!");
          },
        ),
      ),
    );
  }
}
