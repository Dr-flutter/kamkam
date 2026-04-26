import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/alert_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class DashboardMinfefScreen extends StatelessWidget {
  const DashboardMinfefScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = context.watch<AlertService>().alerts;
    final critical = alerts.where((a) => a.level.name == 'critical').length;
    final resolved = alerts.where((a) => a.status == 'resolved').length;
    final rate = alerts.isEmpty ? 0 : ((resolved / alerts.length) * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Tableau MINFEF')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GlassCard(
            gradient: AppColors.primaryGradient,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Données anonymisées',
                style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.5)),
              const SizedBox(height: 6),
              const Text('Indicateurs nationaux',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Row(children: [
                _Stat(label: 'Alertes', value: '${alerts.length}'),
                const SizedBox(width: 12),
                _Stat(label: 'Critiques', value: '$critical'),
                const SizedBox(width: 12),
                _Stat(label: 'Résolues', value: '$rate%'),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('Zones à risque', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            SizedBox(height: 12),
            _Bar(label: 'Yaoundé · Centre', value: 0.78),
            _Bar(label: 'Douala · Littoral', value: 0.62),
            _Bar(label: 'Bafoussam · Ouest', value: 0.41),
            _Bar(label: 'Garoua · Nord', value: 0.33),
          ])),
          const SizedBox(height: 14),
          GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('Indicateurs santé mentale', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            SizedBox(height: 12),
            _Bar(label: 'Stress aigu', value: 0.55, color: AppColors.danger),
            _Bar(label: 'Détresse modérée', value: 0.32, color: AppColors.gold),
            _Bar(label: 'Stable', value: 0.13, color: AppColors.success),
          ])),
          const SizedBox(height: 14),
          GlassCard(child: Row(children: const [
            Icon(Icons.picture_as_pdf, color: AppColors.primary),
            SizedBox(width: 14),
            Expanded(child: Text('Rapport mensuel automatique transmis au MINFEF',
              style: TextStyle(fontSize: 13))),
            Icon(Icons.download_rounded, color: AppColors.primary),
          ])),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ]),
    ));
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _Bar({required this.label, required this.value, this.color = AppColors.primary});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text('${(value * 100).round()}%',
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ]),
    );
  }
}
