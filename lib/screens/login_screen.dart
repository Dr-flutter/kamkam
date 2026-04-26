import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _pin = '';
  String? _error;

  void _press(String d) async {
    if (_pin.length >= 4) return;
    setState(() { _pin += d; _error = null; });
    if (_pin.length == 4) {
      final ok = await context.read<AuthService>().loginWithPin(_pin);
      if (!mounted) return;
      if (ok) {
        context.go('/home');
      } else {
        setState(() { _error = 'Code PIN incorrect'; _pin = ''; });
        HapticFeedback.heavyImpact();
      }
    }
  }

  void _back() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 36),
              ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 24),
              Text('Bon retour', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 8),
              const Text('Entrez votre code PIN',
                style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final filled = i < _pin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 18, height: 18,
                    decoration: BoxDecoration(
                      color: filled ? AppColors.primary : Colors.transparent,
                      border: Border.all(color: AppColors.primary, width: 2),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: AppColors.danger)),
              const Spacer(),
              _Pad(onTap: _press, onBack: _back),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text('Créer un nouveau profil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pad extends StatelessWidget {
  final void Function(String) onTap;
  final VoidCallback onBack;
  const _Pad({required this.onTap, required this.onBack});

  @override
  Widget build(BuildContext context) {
    Widget key(String label, {VoidCallback? action, IconData? icon}) {
      return Expanded(
        child: AspectRatio(
          aspectRatio: 1.5,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: action ?? () => onTap(label),
              child: Center(
                child: icon != null
                  ? Icon(icon, size: 28, color: AppColors.textDark)
                  : Text(label, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ),
      );
    }
    Widget row(List<Widget> w) => Row(children: w);
    return Column(children: [
      row([key('1'), key('2'), key('3')]),
      row([key('4'), key('5'), key('6')]),
      row([key('7'), key('8'), key('9')]),
      row([
        Expanded(child: AspectRatio(aspectRatio: 1.5, child: Container())),
        key('0'),
        key('', action: onBack, icon: Icons.backspace_outlined),
      ]),
    ]);
  }
}
