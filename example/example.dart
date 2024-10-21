import 'package:flutter/material.dart';
import 'package:animated_countdown_timer/animated_countdown_timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Countdown Timer Example')),
        body: Center(
          child: AnimatedCountdownTimer(
            initialCount: 3,
            numFontSize: 40,
            textColor: Colors.black,
            doneTextFontSize: 35,
            doneText: "Smile",
            enableDoneText: false,
            onDone: () {
              print("Timer completed");
            },
            onStart: () {
              print('Timer started');
            },
          ),
        ),
      ),
    );
  }
}
