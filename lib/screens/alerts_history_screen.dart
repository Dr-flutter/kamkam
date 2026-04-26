import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/alert_model.dart';
import '../services/alert_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class AlertsHistoryScreen extends StatelessWidget {
  const AlertsHistoryScreen({super.key});

  Color _color(AlertLevel l) {
    switch (l) {
      case AlertLevel.critical: return AppColors.danger;
      case AlertLevel.moderate: return AppColors.gold;
      case AlertLevel.low: return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    final alerts = context.watch<AlertService>().alerts;
    return Scaffold(
      appBar: AppBar(title: const Text('Historique des alertes')),
      body: alerts.isEmpty
        ? const Center(child: Text('Aucune alerte enregistrée.', style: TextStyle(color: AppColors.textMuted)))
        : ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: alerts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final a = alerts[i];
              return GlassCard(
                child: Row(children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: _color(a.level).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14)),
                    child: Icon(Icons.warning_amber_rounded, color: _color(a.level)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Alerte ${a.level.name.toUpperCase()}',
                      style: TextStyle(fontWeight: FontWeight.w700, color: _color(a.level))),
                    Text(DateFormat('dd MMM yyyy · HH:mm', 'fr').format(a.createdAt),
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    if (a.note.isNotEmpty) Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(a.note, style: const TextStyle(fontSize: 13)),
                    ),
                  ])),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: a.status == 'resolved' ? AppColors.success.withOpacity(0.15) : AppColors.gold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(a.status,
                      style: TextStyle(fontSize: 11, color: a.status == 'resolved' ? AppColors.success : AppColors.gold)),
                  ),
                ]),
              );
            },
          ),
    );
  }
}
