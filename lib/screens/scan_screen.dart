import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../widgets/gradient_border_button.dart';
import '../widgets/gradient_icon.dart';
import '../utils/constants.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  ScanScreenState createState() => ScanScreenState();
}


class ScanScreenState extends State<ScanScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid  // reqd for google ml kit
              ? ImageFormatGroup.nv21
              : ImageFormatGroup.bgra8888
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SafeArea(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: AppDesign.camMaxWidth,
                    maxHeight: AppDesign.camMaxHeight,
                  ),
                  padding: const EdgeInsets.all(AppDesign.camBorderThickness),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDesign.camOuterBorderRadius),
                    gradient: const LinearGradient(
                      colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                    boxShadow: AppDesign.defaultBoxShadows,
                  ),
                  child: SizedBox(
                    child: FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If the Future is complete, display the preview.
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(AppDesign.camInnerBorderRadius),
                            child: CameraPreview(_controller)
                          );
                        } else {
                          // Otherwise, display a loading indicator.
                          return const Center(child: CircularProgressIndicator());
                        }
                      }
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.only(bottom: 20.0, top: 15.0) ,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDesign.bottomBarBorderRadius,
                boxShadow: AppDesign.defaultBoxShadows,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 60.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        overlayColor: Colors.black,
                        padding: EdgeInsets.zero,
                      ),
                      child: GradientIcon(
                        icon: Icons.arrow_back,
                        size: AppDesign.sBtnIconSize,
                        gradient: LinearGradient(colors: [
                          AppDesign.primaryGradientStart,
                          AppDesign.primaryGradientEnd
                        ]),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 120.0,
                    height: 50.0,
                    child: GradientBorderButton(
                      onPressed: () async {

                      },
                      gradient: LinearGradient(colors: [
                          AppDesign.primaryGradientStart,
                          AppDesign.primaryGradientEnd
                        ]),
                      boxShadow: AppDesign.defaultBoxShadows,
                      borderRadius: AppDesign.sBtnBorderRadius,
                      child: GradientIcon(
                        icon: Icons.camera_alt,
                        size: AppDesign.sBtnIconSize,
                        gradient: LinearGradient(colors: [
                          AppDesign.primaryGradientStart,
                          AppDesign.primaryGradientEnd
                        ]),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 60.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        overlayColor: Colors.black,
                        padding: EdgeInsets.zero,
                      ),
                      child: GradientIcon(
                        icon: Icons.upload,
                        size: AppDesign.sBtnIconSize,
                        gradient: LinearGradient(colors: [
                          AppDesign.primaryGradientStart,
                          AppDesign.primaryGradientEnd
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
