import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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
        child: Center(
          child: Container(
            width: AppDesign.cameraPreviewWidth,
            height: AppDesign.cameraPreviewHeight,
            padding: const EdgeInsets.all(AppDesign.cameraPreviewborderThickness),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDesign.cameraPreviewOuterBorderRadius),
              gradient: const LinearGradient(
                colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
              ),
            ),
            child: SizedBox(
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(AppDesign.cameraPreviewInnerBorderRadius),
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
      )
    );
  }
}
