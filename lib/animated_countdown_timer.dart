library animated_countdown_timer;

import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedCountdownTimer extends StatefulWidget {
  final int initialCount;
  final Color textColor;
  final Color overlayColor;
  final VoidCallback? onStart;  // Callback when countdown starts
  final VoidCallback? onDone;   // Callback when countdown ends

  const AnimatedCountdownTimer({
    Key? key,
    this.initialCount = 3, // Default value
    this.textColor = Colors.white, // Default text color
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.7), // Default overlay
    this.onStart,   // User-defined function on start
    this.onDone,    // User-defined function on done
  }) : super(key: key);

  @override
  _AnimatedCountdownTimerState createState() =>
      _AnimatedCountdownTimerState();
}

class _AnimatedCountdownTimerState extends State<AnimatedCountdownTimer>
    with TickerProviderStateMixin {
  late int _count;
  bool _showOverlay = true;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  late AnimationController _goController;
  late Animation<double> _goOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;

    // Trigger the onStart callback when the countdown starts
    if (widget.onStart != null) {
      widget.onStart!();
    }

    _startCountdown();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation =
        Tween<double>(begin: 1.0, end: 1.3).animate(_pulseController);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _rotationAnimation =
        Tween<double>(begin: 0, end: 0.1).animate(_rotationController);

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _colorAnimation = ColorTween(
      begin: widget.textColor,
      end: Colors.red,
    ).animate(_colorController);

    _goController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _goOpacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_goController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _colorController.dispose();
    _goController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_count > 0) {
        setState(() {
          _count--;
        });
        _rotationController.forward(from: 0.0);
      } else {
        timer.cancel();
        _goController.forward();

        // Trigger the onDone callback when the countdown is complete
        if (widget.onDone != null) {
          widget.onDone!();
        }

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _showOverlay = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _showOverlay ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: _showOverlay
            ? Container(
                color: widget.overlayColor,
                child: Center(
                  child: AnimatedBuilder(
                    animation: Listenable.merge(
                        [_pulseAnimation, _rotationAnimation, _colorAnimation]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                  scale: animation, child: child);
                            },
                            child: _count > 0
                                ? Text(
                                    '$_count',
                                    key: ValueKey<int>(_count),
                                    style: TextStyle(
                                      color: _colorAnimation.value,
                                      fontSize: 120,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : _buildGoText(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildGoText() {
    return AnimatedBuilder(
      animation: _goOpacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _goOpacityAnimation.value,
          child: const Text(
            'GO!',
            style: TextStyle(
              color: Colors.green,
              fontSize: 120,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
