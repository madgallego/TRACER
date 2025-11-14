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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        offset: const Offset(4, 4),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      )
                    ]
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
              padding: const EdgeInsets.only(bottom: 30.0, top: 15.0) ,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)
                ),
                boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      offset: const Offset(4, 4),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                  ),
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {

                    },
                    child: Icon(
                      Icons.upload,
                      size: 24.0,
                      semanticLabel: "Upload a picture",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {

                    },
                    child: Icon(
                      Icons.camera,
                      size: 24.0,
                      semanticLabel: "Take picture",
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
