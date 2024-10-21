import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedCountdownTimer extends StatefulWidget {
  final int initialCount;
  final Color textColor;
  final Color overlayColor;
  final bool enableDoneText;
  final double doneTextFontSize;
  final double numFontSize;
  final String doneText;
  final VoidCallback? onStart;
  final VoidCallback? onDone;

  const AnimatedCountdownTimer({
    Key? key,
    this.initialCount = 3,
    this.textColor = Colors.white,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.7),
    this.enableDoneText = true,
    this.doneTextFontSize = 22,
    this.numFontSize = 22,
    this.doneText = "GO!",
    this.onStart,
    this.onDone,
  }) : super(key: key);

  @override
  _AnimatedCountdownTimerState createState() => _AnimatedCountdownTimerState();
}

class _AnimatedCountdownTimerState extends State<AnimatedCountdownTimer>
    with TickerProviderStateMixin {
  late int _count;
  bool _showOverlay = true;
  Timer? _timer; // Store reference to the timer

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  late AnimationController _goController;
  late Animation<double> _goOpacityAnimation;

  bool _showDoneText = false;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;

    widget.onStart?.call(); // Trigger onStart callback
    _setupAnimations();
    _startCountdown();
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

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_count > 1) {
        if (mounted) {
          setState(() {
            _count--;
          });
        }
        _rotationController.forward(from: 0.0);
      } else {
        timer.cancel();

        if (widget.enableDoneText) {
          // If enableDoneText is true, display the doneText after countdown ends
          setState(() {
            _showDoneText = true;
            _count = 0; // Ensure countdown stops at 0
          });
          _goController.forward();
        } else {
          // If enableDoneText is false, end the countdown without showing doneText
          widget.onDone?.call();
          setState(() {
            _showOverlay = false;
          });
        }

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _showOverlay = false;
            });
          }
          widget.onDone?.call(); // Trigger onDone callback
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer
    _pulseController.dispose();
    _rotationController.dispose();
    _colorController.dispose();
    _goController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
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
                              scale: animation,
                              child: child,
                            );
                          },
                          child: _showDoneText
                              ? _buildDoneText()
                              : Text(
                                  '$_count',
                                  key: ValueKey<int>(_count),
                                  style: TextStyle(
                                    color: _colorAnimation.value,
                                    fontSize: widget.numFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildDoneText() {
    return AnimatedBuilder(
      animation: _goOpacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _goOpacityAnimation.value,
          child: Text(
            widget.doneText,
            style: TextStyle(
              color: Colors.green,
              fontSize: widget.doneTextFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
