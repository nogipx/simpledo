import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:simpledo/di.dart';
import 'package:simpledo/screens/main_screen.dart';

Future<void> main() async {
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

  WidgetsFlutterBinding.ensureInitialized();

  final app = Injector(
    child: const MainScreen(),
  );
  await app.init();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://9360e7b51272491188937f9fd92bed0e@o358023.ingest.sentry.io/6346375';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      // options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      MaterialApp(
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
      ),
    ),
  );
}
