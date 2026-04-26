import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      final auth = context.read<AuthService>();
      if (auth.stealthActive) {
        context.go('/stealth');
      } else if (auth.hasAccount) {
        context.go('/login');
      } else {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: const Icon(Icons.shield_moon_rounded, color: Colors.white, size: 60),
              ).animate().scale(duration: 700.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 28),
              Text('KAMKAM',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Colors.white, letterSpacing: 6,
                )).animate().fadeIn(delay: 300.ms, duration: 600.ms),
              const SizedBox(height: 8),
              Text('Kamerun Alerte Mentale',
                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14, letterSpacing: 2),
              ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
              const SizedBox(height: 48),
              const SizedBox(
                width: 28, height: 28,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
