import 'package:flutter/material.dart';

class IsLiveDotAnimation extends StatefulWidget {
  final bool isLive;

  const IsLiveDotAnimation({Key? key, required this.isLive}) : super(key: key);

  @override
  IsLiveDotAnimationState createState() => IsLiveDotAnimationState();
}

class IsLiveDotAnimationState extends State<IsLiveDotAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller);

    if (widget.isLive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(IsLiveDotAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLive && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isLive && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: const Icon(Icons.circle, color: Color(0xFF007012), size: 10),
    );
  }
}