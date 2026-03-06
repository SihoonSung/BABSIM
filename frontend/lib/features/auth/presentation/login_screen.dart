import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(
    text: 'demo@example.com',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: '••••••••',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final scale = ((screenSize.width / 390.0).clamp(0.92, 1.08)).toDouble();

    return Scaffold(
      body: Stack(
        children: [
          const _LoginBackground(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.74),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.26),
                ],
                stops: const [0.0, 0.2, 0.72, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                10.0 * scale,
                6.0 * scale,
                10.0 * scale,
                18.0 * scale,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenSize.height - (24.0 * scale),
                ),
                child: Align(
                  alignment: const Alignment(0, 0.02),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0 * scale),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(maxWidth: 392.0 * scale),
                        padding: EdgeInsets.fromLTRB(
                          22.0 * scale,
                          26.0 * scale,
                          22.0 * scale,
                          24.0 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFBDB4A9,
                          ).withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(30.0 * scale),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.26),
                            width: 1.15,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(21.0 * scale),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 12,
                                  sigmaY: 12,
                                ),
                                child: Container(
                                  width: 80.0 * scale,
                                  height: 80.0 * scale,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFF39454,
                                    ).withValues(alpha: 0.92),
                                    borderRadius: BorderRadius.circular(
                                      21.0 * scale,
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.18,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 40.0 * scale,
                                      height: 40.0 * scale,
                                      child: const _ChefHatMark(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 18.0 * scale),
                            Text(
                              'FridgeMaster',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 31.0 * scale,
                                height: 1.05,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.7,
                              ),
                            ),
                            SizedBox(height: 12.0 * scale),
                            Text(
                              'Manage your ingredients, find recipes,\nand reduce waste.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.0 * scale,
                                height: 1.55,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFF1ECE5),
                              ),
                            ),
                            SizedBox(height: 30.0 * scale),
                            _GlassInputField(
                              controller: _emailController,
                              hintText: 'demo@example.com',
                              icon: Icons.mail_outline_rounded,
                              scale: scale,
                            ),
                            SizedBox(height: 18.0 * scale),
                            _GlassInputField(
                              controller: _passwordController,
                              hintText: '••••••••',
                              icon: Icons.lock_outline_rounded,
                              obscureText: true,
                              scale: scale,
                            ),
                            SizedBox(height: 22.0 * scale),
                            SizedBox(
                              width: double.infinity,
                              height: 62.0 * scale,
                              child: ElevatedButton(
                                onPressed: () => context.go('/home'),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: const Color(0xFFF39454),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      20.0 * scale,
                                    ),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 19.0 * scale,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(width: 12.0 * scale),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 28.0 * scale,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 24.0 * scale),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.0 * scale,
                                      ),
                                    ),
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: const Color(0xFFF0ECE6),
                                        fontSize: 14.0 * scale,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 18.0 * scale,
                                  color: Colors.white.withValues(alpha: 0.45),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10.0 * scale,
                                  ),
                                ),
                                Flexible(
                                  child: TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.0 * scale,
                                      ),
                                    ),
                                    child: Text(
                                      'Create Account',
                                      style: TextStyle(
                                        color: const Color(0xFFF0ECE6),
                                        fontSize: 14.0 * scale,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final double scale;

  const _GlassInputField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0 * scale),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 64.0 * scale,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.018),
            borderRadius: BorderRadius.circular(20.0 * scale),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.16),
              width: 0.95,
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.026),
                  Colors.white.withValues(alpha: 0.008),
                ],
              ),
            ),
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              obscuringCharacter: '•',
              cursorColor: const Color(0xFFF0E5D7).withValues(alpha: 0.82),
              style: TextStyle(
                color: const Color(0xFFF0E5D7).withValues(alpha: 0.78),
                fontSize: 15.5 * scale,
                fontWeight: FontWeight.w400,
              ),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: const Color(0xFFF0E2D3).withValues(alpha: 0.72),
                  fontSize: 15.5 * scale,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(
                    left: 16.0 * scale,
                    right: 10.0 * scale,
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFFF0E4D7).withValues(alpha: 0.76),
                    size: 22.0 * scale,
                  ),
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 48.0 * scale,
                  minHeight: 64.0 * scale,
                ),
                isDense: true,
                contentPadding: EdgeInsets.only(
                  top: 20.0 * scale,
                  right: 18.0 * scale,
                  bottom: 20.0 * scale,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF091014), Color(0xFF1A120A), Color(0xFF080707)],
        ),
      ),
      child: Stack(
        children: const [
          _BlurBlob(
            color: Color(0xFF2F4658),
            alignment: Alignment(-0.74, -0.58),
            size: 300,
          ),
          _BlurBlob(
            color: Color(0xFF8F8D8E),
            alignment: Alignment(0.84, -0.46),
            size: 260,
          ),
          _BlurBlob(
            color: Color(0xFFD8A15A),
            alignment: Alignment(0.02, -0.42),
            size: 250,
          ),
          _BlurBlob(
            color: Color(0xFFF0A323),
            alignment: Alignment(-0.52, -0.30),
            size: 250,
          ),
          _BlurBlob(
            color: Color(0xFFD22A67),
            alignment: Alignment(0.24, -0.18),
            size: 240,
          ),
          _BlurBlob(
            color: Color(0xFF546A22),
            alignment: Alignment(-0.82, -0.12),
            size: 240,
          ),
          _BlurBlob(
            color: Color(0xFFB3291D),
            alignment: Alignment(0.96, 0.06),
            size: 240,
          ),
          _BlurBlob(
            color: Color(0xFFC89D43),
            alignment: Alignment(0.76, -0.22),
            size: 210,
          ),
          _BlurBlob(
            color: Color(0xFF8A2018),
            alignment: Alignment(-0.82, 0.56),
            size: 230,
          ),
          _BlurBlob(
            color: Color(0xFFCEC7B3),
            alignment: Alignment(-0.26, 0.50),
            size: 140,
          ),
          _BlurBlob(
            color: Color(0xFF5F3A19),
            alignment: Alignment(0.32, 0.58),
            size: 240,
          ),
        ],
      ),
    );
  }
}

class _BlurBlob extends StatelessWidget {
  final Color color;
  final Alignment alignment;
  final double size;

  const _BlurBlob({
    required this.color,
    required this.alignment,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 46, sigmaY: 46),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.78),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _ChefHatMark extends StatelessWidget {
  const _ChefHatMark();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ChefHatPainter());
  }
}

class _ChefHatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.24, size.height * 0.68)
      ..lineTo(size.width * 0.24, size.height * 0.54)
      ..quadraticBezierTo(
        size.width * 0.10,
        size.height * 0.53,
        size.width * 0.10,
        size.height * 0.36,
      )
      ..quadraticBezierTo(
        size.width * 0.11,
        size.height * 0.20,
        size.width * 0.28,
        size.height * 0.20,
      )
      ..quadraticBezierTo(
        size.width * 0.36,
        size.height * 0.06,
        size.width * 0.50,
        size.height * 0.07,
      )
      ..quadraticBezierTo(
        size.width * 0.64,
        size.height * 0.06,
        size.width * 0.72,
        size.height * 0.20,
      )
      ..quadraticBezierTo(
        size.width * 0.89,
        size.height * 0.20,
        size.width * 0.90,
        size.height * 0.36,
      )
      ..quadraticBezierTo(
        size.width * 0.90,
        size.height * 0.53,
        size.width * 0.76,
        size.height * 0.54,
      )
      ..lineTo(size.width * 0.76, size.height * 0.68)
      ..close();

    final band = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.24,
        size.height * 0.54,
        size.width * 0.52,
        size.height * 0.19,
      ),
      Radius.circular(size.width * 0.07),
    );

    canvas.drawPath(path, paint);
    canvas.drawRRect(band, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
