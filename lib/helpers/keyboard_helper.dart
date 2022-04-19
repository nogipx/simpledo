import 'dart:async';

import 'package:flutter/cupertino.dart';

mixin KeyboardHelperMixin on WidgetsBindingObserver {
  Future<bool> get isKeyboardHidden async {
    bool check() =>
        (WidgetsBinding.instance?.window.viewInsets.bottom ?? 0) <= 0;
    if (!check()) return false;
    return Future.delayed(const Duration(milliseconds: 100), check);
  }

  // ignore:avoid_positional_boolean_parameters
  FutureOr<void> onKeyboardVisibilityChange(bool isKeyboardHidden);

  @override
  void didChangeMetrics() {
    isKeyboardHidden.then(onKeyboardVisibilityChange);
  }
}
