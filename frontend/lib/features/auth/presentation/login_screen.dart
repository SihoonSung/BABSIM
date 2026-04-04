import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  static const Size _designSize = Size(393, 852);
  bool _isEmailLoading = false;
  bool _isGoogleLoading = false;

  bool _isGmail(String email) {
    return email.trim().toLowerCase().endsWith('@gmail.com');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _showToast(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onSignInPressed() async {
    if (_isEmailLoading) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showToast('Please enter your email and password.');
      return;
    }
    if (!_isGmail(email)) {
      _showToast('Only @gmail.com addresses can sign in.');
      return;
    }

    setState(() {
      _isEmailLoading = true;
    });

    try {
      await AuthService.signInWithEmailPassword(
        email: email,
        password: password,
      );
      if (!mounted) {
        return;
      }
      context.go('/home');
    } catch (_) {
      _showToast('Sign in failed.');
    } finally {
      if (mounted) {
        setState(() {
          _isEmailLoading = false;
        });
      }
    }
  }

  Future<void> _onGoogleSignInPressed() async {
    if (_isGoogleLoading) {
      return;
    }

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      await AuthService.signInWithGoogle();
      if (!mounted) {
        return;
      }
      context.go('/home');
    } catch (_) {
      _showToast('Google sign in failed.');
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;
          final scale =
              (maxWidth / _designSize.width) > (maxHeight / _designSize.height)
              ? (maxWidth / _designSize.width)
              : (maxHeight / _designSize.height);
          final renderWidth = _designSize.width * scale;
          final renderHeight = _designSize.height * scale;
          final offsetX = (maxWidth - renderWidth) / 2;
          final offsetY = (maxHeight - renderHeight) / 2;

          double sx(double value) => offsetX + (value * scale);
          double sy(double value) => offsetY + (value * scale);
          double ss(double value) => value * scale;

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                Positioned(
                  left: offsetX,
                  top: offsetY,
                  width: renderWidth,
                  height: renderHeight,
                  child: Image.asset('assets/images/로그인.png', fit: BoxFit.fill),
                ),
                Positioned(
                  left: sx(36),
                  top: sy(335),
                  width: ss(321),
                  height: ss(58),
                  child: _InputOverlay(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                  ),
                ),
                Positioned(
                  left: sx(36),
                  top: sy(413),
                  width: ss(321),
                  height: ss(58),
                  child: _InputOverlay(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _onSignInPressed(),
                  ),
                ),
                Positioned(
                  left: sx(248),
                  top: sy(486),
                  width: ss(108),
                  height: ss(26),
                  child: _TapOverlay(
                    borderRadius: BorderRadius.circular(ss(10)),
                    onTap: () => context.push('/forgot-password'),
                  ),
                ),
                Positioned(
                  left: sx(24),
                  top: sy(529),
                  width: ss(345),
                  height: ss(57),
                  child: _TapOverlay(
                    borderRadius: BorderRadius.circular(ss(16)),
                    onTap: _isEmailLoading ? null : _onSignInPressed,
                  ),
                ),
                Positioned(
                  left: sx(24),
                  top: sy(628),
                  width: ss(345),
                  height: ss(57),
                  child: _TapOverlay(
                    borderRadius: BorderRadius.circular(ss(16)),
                    onTap: _onGoogleSignInPressed,
                  ),
                ),
                Positioned(
                  left: sx(128),
                  top: sy(730),
                  width: ss(210),
                  height: ss(42),
                  child: _TapOverlay(
                    borderRadius: BorderRadius.circular(ss(10)),
                    onTap: () => context.push('/signup'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InputOverlay extends StatelessWidget {
  const _InputOverlay({
    required this.controller,
    required this.focusNode,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
          color: Color(0xFF9AAAC0),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          filled: false,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          isDense: false,
          contentPadding: EdgeInsets.fromLTRB(52, 16, 12, 16),
        ),
      ),
    );
  }
}

class _TapOverlay extends StatelessWidget {
  const _TapOverlay({required this.onTap, required this.borderRadius});

  final VoidCallback? onTap;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
      ),
    );
  }
}
