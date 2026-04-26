import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/alerts_history_screen.dart';
import '../screens/care_chat_screen.dart';
import '../screens/community_screen.dart';
import '../screens/contacts_screen.dart';
import '../screens/dashboard_minfef_screen.dart';
import '../screens/follow_up_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/men_module_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/post_create_screen.dart';
import '../screens/register_screen.dart';
import '../screens/rights_chat_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/sos_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/stealth_calculator_screen.dart';
import '../screens/stealth_setup_screen.dart';
import '../services/auth_service.dart';

class AppRouter {
  static GoRouter build(BuildContext context) {
    final auth = context.read<AuthService>();

    return GoRouter(
      initialLocation: '/',
      refreshListenable: auth,
      redirect: (ctx, state) {
        final loc = state.matchedLocation;
        if (auth.stealthActive && loc != '/stealth') {
          return '/stealth';
        }
        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
        GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/care', builder: (_, __) => const CareChatScreen()),
        GoRoute(path: '/rights', builder: (_, __) => const RightsChatScreen()),
        GoRoute(path: '/sos', builder: (_, __) => const SosScreen()),
        GoRoute(path: '/contacts', builder: (_, __) => const ContactsScreen()),
        GoRoute(path: '/community', builder: (_, __) => const CommunityScreen()),
        GoRoute(path: '/community/new', builder: (_, __) => const PostCreateScreen()),
        GoRoute(path: '/men', builder: (_, __) => const MenModuleScreen()),
        GoRoute(path: '/follow-up', builder: (_, __) => const FollowUpScreen()),
        GoRoute(path: '/alerts', builder: (_, __) => const AlertsHistoryScreen()),
        GoRoute(path: '/dashboard', builder: (_, __) => const DashboardMinfefScreen()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        GoRoute(path: '/stealth/setup', builder: (_, __) => const StealthSetupScreen()),
        GoRoute(path: '/stealth', builder: (_, __) => const StealthCalculatorScreen()),
      ],
    );
  }
}
