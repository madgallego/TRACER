import 'package:flutter/material.dart';

import 'utils/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:tracer/auth/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Supabase setup
  await Supabase.initialize(
    anonKey: Env.supabaseKey,
    url: Env.supabaseUrl,
  );

  runApp(
    MaterialApp(
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
    )
  );
}
