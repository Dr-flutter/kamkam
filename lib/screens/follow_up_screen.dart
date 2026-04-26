import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class FollowUpScreen extends StatelessWidget {
  const FollowUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _Step('J+1', 'Vérification immédiate', 'KAMKAM s\'assure que vous êtes en sécurité.', true, const Color(0xFFE1BEE7)),
      _Step('J+3', 'Soutien psychologique', 'Réévaluation du score, séance adaptative.', true, const Color(0xFFB2DFDB)),
      _Step('J+7', 'Bilan & orientation', 'Refuge, aide juridique, suivi long terme.', false, const Color(0xFFC8E6C9)),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Suivi post-crise')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          GlassCard(gradient: AppColors.calmGradient, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('KAMKAM reste présente après la crise', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            SizedBox(height: 6),
            Text('Un protocole structuré pour éviter le retour à l\'isolement.',
              style: TextStyle(color: AppColors.textMuted)),
          ])),
          const SizedBox(height: 24),
          for (final s in steps) Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: GlassCard(
              padding: const EdgeInsets.all(18),
              child: Row(children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(16)),
                  child: Center(child: Text(s.day, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(s.desc, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                ])),
                Icon(s.done ? Icons.check_circle : Icons.schedule,
                  color: s.done ? AppColors.success : AppColors.textMuted),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Step {
  final String day, title, desc;
  final bool done;
  final Color color;
  _Step(this.day, this.title, this.desc, this.done, this.color);
}
