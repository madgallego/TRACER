import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityState extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityState() {
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final bool isResultOnline = !results.contains(ConnectivityResult.none);

      if (_isOnline != isResultOnline) {
        _isOnline = isResultOnline;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
