import 'package:flutter/material.dart';

import '../data/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isRequesting = false;
  bool _isResetting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _newPasswordController.dispose();
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

  Future<void> _requestReset() async {
    if (_isRequesting) {
      return;
    }

    final email = _emailController.text.trim();
    if (!email.toLowerCase().endsWith('@gmail.com')) {
      _showToast('Only @gmail.com addresses are allowed.');
      return;
    }

    setState(() {
      _isRequesting = true;
    });

    try {
      final resetToken = await AuthService.requestPasswordReset(email);
      _showToast('Password reset request has been submitted.');

      // Development mode can return a reset token for testing.
      if (resetToken != null && resetToken.isNotEmpty) {
        _tokenController.text = resetToken;
        _showToast('Development reset token has been auto-filled.');
      }
    } catch (e) {
      _showToast('Request failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_isResetting) {
      return;
    }

    final token = _tokenController.text.trim();
    final newPassword = _newPasswordController.text;

    if (token.isEmpty) {
      _showToast('Please enter the reset token.');
      return;
    }
    if (newPassword.length < 8) {
      _showToast('New password must be at least 8 characters.');
      return;
    }

    setState(() {
      _isResetting = true;
    });

    try {
      await AuthService.resetPassword(token: token, newPassword: newPassword);
      _showToast('Password updated. Please sign in again.');
    } catch (e) {
      _showToast('Password update failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isResetting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isRequesting ? null : _requestReset,
              child: Text(
                _isRequesting ? 'Requesting...' : 'Request reset email',
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(labelText: 'Reset token'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New password'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isResetting ? null : _resetPassword,
              child: Text(_isResetting ? 'Updating...' : 'Update password'),
            ),
          ],
        ),
      ),
    );
  }
}
