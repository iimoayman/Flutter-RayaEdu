import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayaedu/theme/app_colors.dart';
import 'package:rayaedu/model/network/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final valid = await _authService.isTokenValid();
    if (!mounted) return;

    if (valid) {
      context.go('/portal');
    } else {
      context.go('/loading');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF005E39),
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}