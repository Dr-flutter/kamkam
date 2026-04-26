import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RiskBadge extends StatelessWidget {
  final int score;
  const RiskBadge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    Color c;
    String label;
    if (score >= 70) { c = AppColors.danger; label = 'Critique'; }
    else if (score >= 40) { c = AppColors.gold; label = 'Modéré'; }
    else { c = AppColors.success; label = 'Bas'; }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: c.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text('Risque · $label · $score',
            style: TextStyle(color: c, fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}
