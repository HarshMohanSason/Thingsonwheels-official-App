import 'package:flutter/material.dart';

class LiveIndicatorButtonProfile extends StatefulWidget {
  final bool isLive;
  final VoidCallback onTap;

  const LiveIndicatorButtonProfile({Key? key, required this.isLive, required this.onTap})
      : super(key: key);

  @override
  LiveIndicatorButtonProfileState createState() => LiveIndicatorButtonProfileState();
}

class LiveIndicatorButtonProfileState extends State<LiveIndicatorButtonProfile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isLive ? Colors.green : Colors.red,
              boxShadow: [
                BoxShadow(
                  color: widget.isLive
                      ? Colors.green.withOpacity(0.5)
                      : Colors.red.withOpacity(0.5),
                  blurRadius: _controller.value * 10,
                  spreadRadius: _controller.value * 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.online_prediction,
              color: Colors.white,
              size: 30,
            ),
          );
        },
      ),
    );
  }
}
