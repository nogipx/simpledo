import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_task/di.dart';
import 'package:test_task/screens/main_screen.dart';

void main() {
  runZonedGuarded(
    () async {
      final app = Injector(
        child: const MainScreen(),
      );
      await app.init();
      runApp(MaterialApp(
        home: app,
      ));
    },
    (error, stackTrace) {},
  );
}
