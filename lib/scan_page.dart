import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'gradient_border_button.dart';
import 'gradient_icon.dart';
import 'constants.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key, required this.camera});

  final CameraDescription camera;

  @override
  ScanPageState createState() => ScanPageState();
}


class ScanPageState extends State<ScanPage> {
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
            Padding(
              padding: const EdgeInsets.only(top: AppDesign.camTopPadding),
              child: Center(
                child: Container(
                  width: AppDesign.camWidth,
                  height: AppDesign.camHeight,
                  padding: const EdgeInsets.all(AppDesign.camBorderThickness),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDesign.camOuterBorderRadius),
                    gradient: const LinearGradient(
                      colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                    boxShadow: [AppDesign.defaultBoxShadow],
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
              padding: const EdgeInsets.only(bottom: 30.0, top: 20.0) ,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDesign.bottomBarBorderRadius,
                boxShadow: [AppDesign.defaultBoxShadow],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
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
                      boxShadow: [AppDesign.defaultBoxShadow],
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
                    width: 120.0,
                    height: 50.0,
                    child: GradientBorderButton(
                      onPressed: () async {

                      },
                      gradient: LinearGradient(colors: [
                          AppDesign.primaryGradientStart,
                          AppDesign.primaryGradientEnd
                        ]),
                      boxShadow: [AppDesign.defaultBoxShadow],
                      borderRadius: AppDesign.sBtnBorderRadius,
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
