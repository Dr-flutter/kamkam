import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/feature_tile.dart';
import '../widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().current;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bonjour ${user?.displayName ?? ''} 🌸',
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('Vous êtes en sécurité.',
                            style: Theme.of(context).textTheme.displayMedium),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.push('/settings'),
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.settings_outlined, color: AppColors.textDark),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0),
            ),

            // Hero SOS
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: GlassCard(
                  gradient: AppColors.warmGradient,
                  padding: const EdgeInsets.all(24),
                  onTap: () => context.push('/sos'),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Bouton SOS', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                            SizedBox(height: 4),
                            Text('Alerte silencieuse · Police · MINFEF · Contact',
                              style: TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                    ],
                  ),
                ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 1.05,
                ),
                delegate: SliverChildListDelegate.fixed([
                  FeatureTile(index: 0, icon: Icons.psychology_alt_rounded, title: 'KAMKAM Care',
                    subtitle: 'Psychologue IA, à votre écoute',
                    color: AppColors.primary, onTap: () => context.push('/care')),
                  FeatureTile(index: 1, icon: Icons.gavel_rounded, title: 'Mes Droits',
                    subtitle: 'Recours, démarches, lois',
                    color: AppColors.gold, onTap: () => context.push('/rights')),
                  FeatureTile(index: 2, icon: Icons.people_alt_rounded, title: 'Contacts',
                    subtitle: 'Réseau de confiance',
                    color: AppColors.accent, onTap: () => context.push('/contacts')),
                  FeatureTile(index: 3, icon: Icons.forum_rounded, title: 'KAMKAM Espace',
                    subtitle: 'Forum anonyme entre femmes',
                    color: const Color(0xFF2E7D5B), onTap: () => context.push('/community')),
                  FeatureTile(index: 4, icon: Icons.calendar_today_rounded, title: 'Suivi post-crise',
                    subtitle: 'J+1, J+3, J+7',
                    color: const Color(0xFF1976D2), onTap: () => context.push('/follow-up')),
                  FeatureTile(index: 5, icon: Icons.self_improvement_rounded, title: 'Module Hommes',
                    subtitle: 'Gérer la colère, prévenir',
                    color: const Color(0xFF6D4C41), onTap: () => context.push('/men')),
                  FeatureTile(index: 6, icon: Icons.history_rounded, title: 'Mes alertes',
                    subtitle: 'Historique des signalements',
                    color: const Color(0xFFD84315), onTap: () => context.push('/alerts')),
                  FeatureTile(index: 7, icon: Icons.dashboard_rounded, title: 'Tableau MINFEF',
                    subtitle: 'Indicateurs anonymisés',
                    color: const Color(0xFF512DA8), onTap: () => context.push('/dashboard')),
                ]),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: GlassCard(
                  onTap: () => context.push('/stealth/setup'),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.visibility_off_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Mode discret KAMKAM Mama',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          SizedBox(height: 2),
                          Text('Déguiser l\'application pour plus de sécurité',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
