import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  final _pages = const [
    _OnbData(
      icon: Icons.psychology_alt_rounded,
      title: 'Une oreille bienveillante',
      desc: 'KAMKAM Care, une IA psychologique formée aux réalités camerounaises, à votre écoute 24h/24.',
      color: Color(0xFF7E57C2),
    ),
    _OnbData(
      icon: Icons.shield_rounded,
      title: 'Protection discrète',
      desc: 'Mode camouflage, mots de code SMS, alertes silencieuses vers vos contacts de confiance.',
      color: Color(0xFFE91E63),
    ),
    _OnbData(
      icon: Icons.gavel_rounded,
      title: 'Vos droits, expliqués',
      desc: 'Chatbot juridique en 6 langues. Connaissez vos recours et les démarches à suivre.',
      color: Color(0xFFFFB300),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _OnbPage(data: _pages[i]),
              ),
            ),
            // Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8, height: 8,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                label: _page == _pages.length - 1 ? 'Commencer' : 'Continuer',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  if (_page == _pages.length - 1) {
                    context.go('/register');
                  } else {
                    _controller.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnbData {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  const _OnbData({required this.icon, required this.title, required this.desc, required this.color});
}

class _OnbPage extends StatelessWidget {
  final _OnbData data;
  const _OnbPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Parallax-like layered illustration
          SizedBox(
            height: 320,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 280, height: 280,
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                ).animate().scale(duration: 800.ms, curve: Curves.easeOut),
                Container(
                  width: 200, height: 200,
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                ).animate().scale(delay: 100.ms, duration: 800.ms, curve: Curves.easeOut),
                Container(
                  width: 130, height: 130,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [data.color, data.color.withOpacity(0.6)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: data.color.withOpacity(0.4), blurRadius: 30, offset: const Offset(0, 12))],
                  ),
                  child: Icon(data.icon, color: Colors.white, size: 60),
                ).animate().scale(delay: 200.ms, duration: 700.ms, curve: Curves.easeOutBack),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Text(data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          Text(data.desc,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.textMuted),
          ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}
