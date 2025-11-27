import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/transaction.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  // Methods for data fetching and processing


  // User interface
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(), // Removes keyboard when tapping outside input fields
      child: Scaffold(
        body: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                ),
              ),
            ),

            // Main content
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      const Text(
                        'Records',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20.0),

                      // Records list placeholder
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Records list will be displayed here.',
                            style: TextStyle(fontSize: 16.0, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}