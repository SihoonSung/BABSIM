import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return ScaleTransition(
          scale: DelayTween(
            begin: 0.0,
            end: 1.0,
            delay: index * 0.2,
          ).animate(_controller),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: CircleAvatar(radius: 5, backgroundColor: Colors.orange),
          ),
        );
      }),
    );
  }
}

class DelayTween extends Tween<double> {
  DelayTween({required double begin, required double end, required this.delay})
    : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((t - delay).clamp(0.0, 1.0));
  }
}
