import 'package:flutter/material.dart';

class LiveIndicator extends StatefulWidget {
  final bool isLive;
  final double size;

  LiveIndicator({Key? key, required this.isLive, required this.size}) : super(key: key);

  @override
  LiveIndicatorState createState() => LiveIndicatorState();
}

class LiveIndicatorState extends State<LiveIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller);
    if (widget.isLive) {
      _controller.forward();
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
      child: Icon(
        Icons.circle,
        color: widget.isLive ? Colors.green : Colors.transparent,
        size: widget.size,
      ),
    );
  }
}