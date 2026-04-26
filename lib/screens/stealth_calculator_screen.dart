import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

/// Calculatrice de couverture : entrer le PIN puis appuyer "=" pour ouvrir KAMKAM.
class StealthCalculatorScreen extends StatefulWidget {
  const StealthCalculatorScreen({super.key});
  @override
  State<StealthCalculatorScreen> createState() => _StealthCalculatorScreenState();
}

class _StealthCalculatorScreenState extends State<StealthCalculatorScreen> {
  String _expr = '0';

  void _press(String k) async {
    setState(() {
      if (_expr == '0' && RegExp(r'\d').hasMatch(k)) {
        _expr = k;
      } else if (k == 'C') {
        _expr = '0';
      } else if (k == '=') {
        _tryUnlock();
      } else {
        _expr += k;
      }
    });
  }

  Future<void> _tryUnlock() async {
    final pin = _expr.replaceAll(RegExp(r'\D'), '');
    final auth = context.read<AuthService>();
    if (pin.length == 4 && await auth.loginWithPin(pin)) {
      await auth.deactivateStealth();
      if (mounted) context.go('/home');
    } else {
      setState(() => _expr = '0');
    }
  }

  Widget _key(String label, {Color? bg, Color? fg, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Material(
          color: bg ?? const Color(0xFF333333),
          borderRadius: BorderRadius.circular(40),
          child: InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: () => _press(label),
            child: Container(
              height: 70, alignment: Alignment.center,
              child: Text(label,
                style: TextStyle(color: fg ?? Colors.white, fontSize: 28, fontWeight: FontWeight.w400)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(_expr,
                  style: const TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.w200)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(children: [
              Row(children: [
                _key('C', bg: const Color(0xFFA5A5A5), fg: Colors.black),
                _key('±', bg: const Color(0xFFA5A5A5), fg: Colors.black),
                _key('%', bg: const Color(0xFFA5A5A5), fg: Colors.black),
                _key('÷', bg: const Color(0xFFFF9F0A)),
              ]),
              Row(children: [_key('7'), _key('8'), _key('9'), _key('×', bg: const Color(0xFFFF9F0A))]),
              Row(children: [_key('4'), _key('5'), _key('6'), _key('−', bg: const Color(0xFFFF9F0A))]),
              Row(children: [_key('1'), _key('2'), _key('3'), _key('+', bg: const Color(0xFFFF9F0A))]),
              Row(children: [_key('0', flex: 2), _key('.'), _key('=', bg: const Color(0xFFFF9F0A))]),
            ]),
          ),
        ]),
      ),
    );
  }
}
