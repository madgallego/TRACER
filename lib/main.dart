import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tracer/services/db_service.dart';

import 'package:tracer/auth/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbService = await DbService.initialize();

  runApp(
    Provider<DbService>.value(
      value: dbService,

      child: MaterialApp(
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              overlayColor: Colors.black,
              padding: EdgeInsets.zero,
            )
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
      ),
    )
  );
}
