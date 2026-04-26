import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/alert_model.dart';
import 'models/contact_model.dart';
import 'models/message_model.dart';
import 'models/post_model.dart';
import 'models/user_model.dart';
import 'routes/app_router.dart';
import 'services/alert_service.dart';
import 'services/auth_service.dart';
import 'services/care_service.dart';
import 'services/community_service.dart';
import 'services/contacts_service.dart';
import 'services/locale_service.dart';
import 'services/seed_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ContactModelAdapter());
  Hive.registerAdapter(MessageModelAdapter());
  Hive.registerAdapter(AlertModelAdapter());
  Hive.registerAdapter(AlertLevelAdapter());
  Hive.registerAdapter(PostModelAdapter());

  await Future.wait([
    Hive.openBox<UserModel>('users'),
    Hive.openBox<ContactModel>('contacts'),
    Hive.openBox<MessageModel>('messages'),
    Hive.openBox<AlertModel>('alerts'),
    Hive.openBox<PostModel>('posts'),
    Hive.openBox('settings'),
  ]);

  await SeedService.seedIfEmpty();

  runApp(const KamKamApp());
}

class KamKamApp extends StatelessWidget {
  const KamKamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()..load()),
        ChangeNotifierProvider(create: (_) => ContactsService()..load()),
        ChangeNotifierProvider(create: (_) => CareService()..load()),
        ChangeNotifierProvider(create: (_) => AlertService()..load()),
        ChangeNotifierProvider(create: (_) => CommunityService()..load()),
        ChangeNotifierProvider(create: (_) => LocaleService()..load()),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.build(context);
          return MaterialApp.router(
            title: 'KAMKAM',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
