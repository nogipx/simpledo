import 'dart:async';

import 'package:feature_source_firebase/feature_source_firebase.dart';
import 'package:feature_source_retain/feature_source_retain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpledo/di.dart';
import 'package:simpledo/features.dart';
import 'package:simpledo/firebase_options.dart';
import 'package:simpledo/screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    // iOS
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.light,

    // Android
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();

  final featureManager = Features.connect(
    instance: FeaturesManager(
      sources: {
        RetainFeatureSourceWrapper(
          name: 'Настройки UI',
          tag: 'ui',
          preferences: prefs,
          source: TogglingFeatureSourceWrapper(
            source: LocalFeatureSource(
              features: [
                UseWeekDaysToggle(),
              ],
            ),
          ),
        ),
        RetainFeatureSourceWrapper(
          tag: 'firebase',
          preferences: prefs,
          name: 'Фичи с firebase сохраняющиеся',
          source: TogglingFeatureSourceWrapper(
            source: FirebaseFeatureSource(
              remoteConfig: FirebaseRemoteConfig.instance,
              minimumFetchInterval:
                  kDebugMode ? Duration.zero : const Duration(hours: 12),
            ),
          ),
        ),
      },
    ),
  );
  await featureManager.init();

  await runZonedGuarded(
    () async {
      final app = Injector(
        child: const MainScreen(),
      );
      await app.init();
      runApp(MaterialApp(
        home: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          child: app,
        ),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(),
        ),
      ));
    },
    (error, stackTrace) {},
  );
}
