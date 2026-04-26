import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/primary_button.dart';

class StealthSetupScreen extends StatefulWidget {
  const StealthSetupScreen({super.key});
  @override
  State<StealthSetupScreen> createState() => _StealthSetupScreenState();
}

class _StealthSetupScreenState extends State<StealthSetupScreen> {
  String _disguise = 'calculator';

  static const _options = [
    ('calculator', 'Calculatrice', Icons.calculate_rounded, Color(0xFF455A64)),
    ('recipe', 'Recettes', Icons.restaurant_rounded, Color(0xFFE65100)),
    ('weather', 'Météo', Icons.wb_sunny_rounded, Color(0xFFFB8C00)),
    ('calendar', 'Agenda', Icons.calendar_today_rounded, Color(0xFF2E7D32)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mode discret')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          GlassCard(
            gradient: AppColors.calmGradient,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('KAMKAM Mama', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              SizedBox(height: 6),
              Text('Déguisez l\'application en outil banal. Personne ne saura que KAMKAM est installé.',
                style: TextStyle(color: AppColors.textMuted, height: 1.5)),
            ]),
          ),
          const SizedBox(height: 24),
          const Text('Choisissez un déguisement', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.1,
            children: _options.map((o) {
              final selected = _disguise == o.$1;
              return GlassCard(
                onTap: () => setState(() => _disguise = o.$1),
                color: selected ? o.$4.withOpacity(0.1) : Colors.white,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: o.$4.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
                    child: Icon(o.$3, color: o.$4, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(o.$2, style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (selected) const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(Icons.check_circle, color: AppColors.success, size: 18),
                  ),
                ]),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const GlassCard(child: Row(children: [
            Icon(Icons.info_outline, color: AppColors.primary),
            SizedBox(width: 12),
            Expanded(child: Text(
              'Pour revenir à KAMKAM : tapez votre code PIN dans la calculatrice puis ouvrez "=" deux fois.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.5))),
          ])),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Activer le mode discret',
            icon: Icons.visibility_off_rounded,
            onPressed: () async {
              final auth = context.read<AuthService>();
              await auth.setStealthDisguise(_disguise);
              await auth.activateStealth();
              if (mounted) context.go('/stealth');
            },
          ),
        ],
      ),
    );
  }
}
