import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  static const Size _designSize = Size(393, 852);
  late final AnimationController _controller;

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          context.go('/login');
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
            final scale =
                (maxWidth / _designSize.width) >
                    (maxHeight / _designSize.height)
                ? (maxWidth / _designSize.width)
                : (maxHeight / _designSize.height);
            final renderWidth = _designSize.width * scale;
            final renderHeight = _designSize.height * scale;
            final offsetX = (maxWidth - renderWidth) / 2;
            final offsetY = (maxHeight - renderHeight) / 2;

            double sx(double value) => offsetX + (value * scale);
            double sy(double value) => offsetY + (value * scale);
            double ss(double value) => value * scale;

            return Stack(
              children: [
                Positioned(
                  left: offsetX,
                  top: offsetY,
                  width: renderWidth,
                  height: renderHeight,
                  child: Image.asset('assets/images/로딩딩.png', fit: BoxFit.fill),
                ),
                Positioned(
                  // Cover baked-in static dots from the background image.
                  left: sx(158),
                  top: sy(536),
                  width: ss(78),
                  height: ss(28),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(ss(16)),
                    ),
                  ),
                ),
                Positioned(
                  // Draw a single animated indicator at the original dot position.
                  left: sx(180),
                  top: sy(545),
                  width: ss(32),
                  height: ss(10),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(3, (index) {
                          final phase =
                              (_controller.value + (index * 0.22)) % 1.0;
                          final pulse =
                              0.35 +
                              (0.65 *
                                  (0.5 + 0.5 * math.sin(phase * math.pi * 2)));
                          return Container(
                            width: ss(10),
                            height: ss(10),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFEEA46B,
                              ).withValues(alpha: pulse),
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
