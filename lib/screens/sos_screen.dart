import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/alert_model.dart';
import '../services/alert_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});
  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  AlertLevel _level = AlertLevel.critical;
  final _note = TextEditingController();
  bool _sending = false;

  Future<void> _send() async {
    HapticFeedback.heavyImpact();
    setState(() => _sending = true);
    await Future.delayed(const Duration(milliseconds: 800));
    final a = await context.read<AlertService>().trigger(
      level: _level, note: _note.text.trim());
    if (!mounted) return;
    setState(() => _sending = false);
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      icon: const Icon(Icons.shield_rounded, color: AppColors.success, size: 48),
      title: const Text('Alerte transmise'),
      content: Text('Code d\'alerte ${a.id.substring(0,6).toUpperCase()} envoyé silencieusement à la police, au MINFEF et à votre contact de confiance.'),
      actions: [
        TextButton(onPressed: () { Navigator.pop(context); context.go('/home'); }, child: const Text('OK')),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerte SOS')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassCard(
              gradient: AppColors.warmGradient,
              child: Row(children: const [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text(
                  'Cette alerte est anonyme et géolocalisée. Elle sera reçue immédiatement par les autorités.',
                  style: TextStyle(color: Colors.white, height: 1.4),
                )),
              ]),
            ).animate().fadeIn(),
            const SizedBox(height: 24),
            const Text('Niveau de danger', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            for (final l in AlertLevel.values) _LevelTile(
              level: l,
              selected: _level == l,
              onTap: () => setState(() => _level = l),
            ),
            const SizedBox(height: 24),
            const Text('Note (facultatif)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(
              controller: _note, maxLines: 4,
              decoration: const InputDecoration(hintText: 'Décrivez la situation en quelques mots…'),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 64,
              child: ElevatedButton(
                onPressed: _sending ? null : _send,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: _sending
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.notifications_active_rounded, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Envoyer l\'alerte', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  final AlertLevel level;
  final bool selected;
  final VoidCallback onTap;
  const _LevelTile({required this.level, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final config = {
      AlertLevel.low: ('Bas', 'Inconfort, vigilance', AppColors.success),
      AlertLevel.moderate: ('Modéré', 'Tensions, peur', AppColors.gold),
      AlertLevel.critical: ('Critique', 'Danger immédiat', AppColors.danger),
    }[level]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        onTap: onTap,
        color: selected ? config.$3.withOpacity(0.08) : Colors.white,
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(width: 14, height: 14,
            decoration: BoxDecoration(
              color: selected ? config.$3 : Colors.transparent,
              border: Border.all(color: config.$3, width: 2),
              shape: BoxShape.circle)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(config.$1, style: TextStyle(fontWeight: FontWeight.w700, color: config.$3)),
            Text(config.$2, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
          ])),
        ]),
      ),
    );
  }
}
