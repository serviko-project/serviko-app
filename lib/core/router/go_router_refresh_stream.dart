import 'dart:async';
import 'package:flutter/material.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  GoRouterRefreshStream(List<Stream<dynamic>> streams) {
    notifyListeners();
    for (final stream in streams) {
      _subscriptions.add(
        stream.asBroadcastStream().listen((_) => notifyListeners()),
      );
    }
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}
