import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:tracer/screens/scan_confirmation_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/gradient_border_button.dart';
import '../widgets/gradient_icon.dart';
import '../utils/constants.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  ScanScreenState createState() => ScanScreenState();
}


class ScanScreenState extends State<ScanScreen> {
  late CameraController _controller;
  late CameraDescription camera;
  late Future<void> _cameraSetupFuture = Future.value();

  final _picker = ImagePicker();
  File? _image;

  Future<String> _correctImageOrientation(String imagePath, int rotationAngle) async {
  final File file = File(imagePath);

  img.Image? originalImage = img.decodeImage(file.readAsBytesSync());

  if (originalImage == null) {
    throw Exception("Could not decode image for rotation.");
  }

  if (rotationAngle != 0) {
    originalImage = img.copyRotate(originalImage, angle: rotationAngle);
  }

  final correctedBytes = img.encodeJpg(originalImage);
  await file.writeAsBytes(correctedBytes);

  return file.path;
}

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _image = File(pickedImage.path);
    }
  }

  Future<void> _initCamera() async {
    camera = (await availableCameras())[0];

    _controller = CameraController(
      camera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid  // reqd for google ml kit
              ? ImageFormatGroup.nv21
              : ImageFormatGroup.bgra8888
    );

    final Future<void> initControllerFuture =  _controller.initialize();
    await initControllerFuture;
  }

  @override
  void initState() {
    super.initState();
    _cameraSetupFuture = _initCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size of the gesture hint / navbar at the bottom of the screen
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
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
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: AppDesign.defaultBoxShadows,
                ),
                child: FutureBuilder<void>(
                  future: _cameraSetupFuture,
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

            const SizedBox(
              height: 10.0,
            ),

            Container(
              // Factor in gesture hint / navbar space
              height: 90.0 + bottomInset,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0 + bottomInset, right: 10.0, left: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDesign.bottomBarBorderRadius,
                boxShadow: AppDesign.defaultBoxShadows,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: AppDesign.camBtnWidth,
                    height: AppDesign.camBtnHeight,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: GradientIcon(
                        icon: Icons.close,
                        size: AppDesign.sBtnIconSize,
                        gradient: LinearGradient(colors: [
                          AppDesign.primaryGradientStart,
                          AppDesign.primaryGradientEnd
                        ]),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: AppDesign.camBtnWidth + 80.0,
                    height: AppDesign.camBtnHeight + 5.0,
                    child: GradientBorderButton(
                      onPressed: () async {
                        try {
                          await _cameraSetupFuture;

                          if (!context.mounted) return;

                          final deviceOrientation = await NativeDeviceOrientationCommunicator().orientation(useSensor: true);
                          int rotationAngle = 0;

                          if (deviceOrientation == NativeDeviceOrientation.landscapeRight) {
                            rotationAngle = 90;
                          } else if (deviceOrientation == NativeDeviceOrientation.landscapeLeft) {
                            rotationAngle = 270;
                          } else if (deviceOrientation == NativeDeviceOrientation.portraitDown) {
                            rotationAngle = 180;
                          }

                          final image = await _controller.takePicture();
                          final correctedImagePath = await _correctImageOrientation(image.path, rotationAngle);

                          await _controller.pausePreview();

                          if (!context.mounted) return;

                          // If the picture was taken, display it on a new screen.
                          await Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) => ScanConfirmationScreen(
                                imagePath: correctedImagePath,
                              ),
                            ),
                          );

                          if (_controller.value.isInitialized) {
                            await _controller.resumePreview();
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      gradient: LinearGradient(colors: [
                          AppDesign.primaryGradientStart,
                          AppDesign.primaryGradientEnd
                        ]),
                      borderRadius: AppDesign.sBtnBorderRadius,
                      child: GradientIcon(
                        icon: Icons.camera_rounded,
                        size: AppDesign.sBtnIconSize,
                        gradient: LinearGradient(colors: [
                          AppDesign.primaryGradientStart,
                          AppDesign.primaryGradientEnd
                        ]),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: AppDesign.camBtnWidth,
                    height: AppDesign.camBtnHeight,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _controller.pausePreview();

                        await _openImagePicker();

                        if (_image == null) {
                          if (_controller.value.isInitialized) {
                            await _controller.resumePreview();
                          }
                          return;
                        }

                        if (!context.mounted) return;

                        // If the picture a picture was chosen, display it on the new screen
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => ScanConfirmationScreen(
                              imagePath: _image!.path,
                            ),
                          ),
                        );

                        _image = null;

                        if (_controller.value.isInitialized) {
                          await _controller.resumePreview();
                        }
                      },
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
      ),
    );
  }
}
