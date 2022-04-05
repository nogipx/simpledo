import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

void main() {
  runZonedGuarded(
    () {
      runApp(const SizedBox());
    },
    (error, stackTrace) {},
  );
}
