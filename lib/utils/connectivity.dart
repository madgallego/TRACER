import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracer/widgets/error_snackbar.dart';
import 'package:tracer/widgets/gradient_border_snackbar.dart';
import 'package:tracer/widgets/warning_snackbar.dart';

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

class GlobalConnectivityListener extends StatefulWidget {
  final Widget child;

  const GlobalConnectivityListener({
    super.key,
    required this.child
  });


  @override
  State<GlobalConnectivityListener> createState() => _GlobalConnectivityListenerState();
}

class _GlobalConnectivityListenerState extends State<GlobalConnectivityListener> {
  bool _isInitialSync = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final isOnline = Provider.of<ConnectivityState>(context).isOnline;

    if (_isInitialSync) {
      _isInitialSync = false;
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isOnline) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          GradientBorderSnackbar(message: 'You\'re back online!')
        );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        WarningSnackbar.show(
          context,
          'Please check your internet connection',
          icon: Icons.wifi_off
        );
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
