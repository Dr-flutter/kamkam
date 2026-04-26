import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/locale_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final locale = context.watch<LocaleService>();
    final user = auth.current;
    final wordC = TextEditingController(text: user?.safeWord ?? '');

    return Scaffold(
      appBar: AppBar(title: const Text('Réglages')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GlassCard(
            gradient: AppColors.calmGradient,
            child: Row(children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary,
                child: Text(user?.displayName.substring(0, 1).toUpperCase() ?? 'K',
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user?.displayName ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                Text('Profil anonyme · KAMKAM', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ])),
            ]),
          ),
          const SizedBox(height: 20),

          const _Section(title: 'Sécurité'),
          GlassCard(child: Column(children: [
            const Text('Mot de code SMS', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: wordC,
              decoration: InputDecoration(
                hintText: 'Ex: j\'ai besoin de farine',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.save, color: AppColors.primary),
                  onPressed: () => auth.updateSafeWord(wordC.text),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Envoyé à un contact, ce SMS déclenchera une alerte silencieuse géolocalisée.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ])),
          const SizedBox(height: 12),
          GlassCard(
            onTap: () => context.push('/stealth/setup'),
            child: Row(children: const [
              Icon(Icons.visibility_off_rounded, color: AppColors.primary),
              SizedBox(width: 14),
              Expanded(child: Text('Configurer le mode discret', style: TextStyle(fontWeight: FontWeight.w600))),
              Icon(Icons.chevron_right, color: AppColors.textMuted),
            ]),
          ),

          const SizedBox(height: 24),
          const _Section(title: 'Langue'),
          GlassCard(child: Wrap(spacing: 8, runSpacing: 8, children: LocaleService.supported.entries.map((e) =>
            ChoiceChip(label: Text(e.value), selected: locale.lang == e.key,
              onSelected: (_) { locale.set(e.key); auth.updateLanguage(e.key); }),
          ).toList())),

          const SizedBox(height: 24),
          const _Section(title: 'À propos'),
          GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('KAMKAM v1.0.0', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('Kamerun Alerte Mentale · MINFEF Cameroun',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            SizedBox(height: 8),
            Text('Toutes vos données restent stockées localement, chiffrées sur votre téléphone.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ])),

          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () { auth.logout(); context.go('/login'); },
            icon: const Icon(Icons.logout, color: AppColors.danger),
            label: const Text('Se déconnecter', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(title.toUpperCase(),
        style: const TextStyle(fontSize: 12, color: AppColors.textMuted, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
    );
  }
}
