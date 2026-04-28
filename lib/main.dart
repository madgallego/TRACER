import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracer/models/transaction.dart';

import 'package:tracer/services/db_service.dart';
import 'package:tracer/auth/auth_gate.dart';

import 'package:tracer/screens/home_screen.dart';
import 'package:tracer/screens/login_screen.dart';
import 'package:tracer/screens/scan_screen.dart';
import 'package:tracer/screens/scan_confirmation_screen.dart';
import 'package:tracer/screens/data_verification_screen.dart';
import 'package:tracer/screens/records_screen.dart';
import 'package:tracer/screens/settings_screen.dart';
import 'package:tracer/screens/signup_screen.dart';

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

        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (settings.name == '/scan_confirmation') {
            final args = settings.arguments as String; // Retrieve the path
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => ScanConfirmationScreen(imagePath: args),
            );

          }
          else if (settings.name == '/verification') {
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => DataVerificationScreen(
                transaction: args['transaction'] as Transaction,
                isFromHomeScreen: args['isFromHomeScreen'] as bool? ?? false,
              ),
            );
          }
          return null; // Fallback to the routes map below
        },

        routes: {
          '/': (context) => const AuthGate(),
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/records': (context) => const RecordsScreen(),
          '/scan': (context) => const ScanScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/signup': (context) => const SignupScreen(),
        },
      ),
    )
  );
}
