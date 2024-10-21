<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

TODO:A Flutter package that provides a sleek and customizable countdown timer widget with animations and lifecycle callbacks for starting and completing the countdown. Perfect for use in splash screens, games, timed challenges, or any scenario where a countdown enhances the user experience.

## Features

Customizable Countdown: Set the countdown duration, text color, and overlay background color.
Animated Effects: Smooth scaling, rotating, and color animations.
Lifecycle Callbacks: onStart and onDone events to trigger custom logic.
Simple and Lightweight: Easy to integrate with minimal configuration.

## Getting started

To use this package, add it to your pubspec.yaml dependencies:

dependencies:
  animated_countdown_timer: latest

Run the following command to install it:
flutter pub get

## Usage

import 'package:flutter/material.dart';
import 'package:animated_countdown_timer/animated_countdown_timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: AnimatedCountdownTimer(
            initialCount: 5,
            textColor: Colors.yellow,
            overlayColor: Colors.black54,
            onStart: () => print("Countdown started!"),
            onDone: () => print("Countdown finished!"),
          ),
        ),
      ),
    );
  }
}


## Additional information

Parameters
initialCount:	int	The starting number for the countdown.	3
textColor:	Color	Color of the countdown text.	Colors.white
overlayColor:	Color	Background overlay color.	Color(0xB3000000)
onStart	VoidCallback?:	Callback triggered when countdown starts.	null
onDone	VoidCallback?:	Callback triggered when countdown finishes.	null
