import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:tracer/models/transaction.dart';
import 'package:tracer/screens/data_verification_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracer/services/ocr_service.dart';

import '../widgets/gradient_border_button.dart';
import '../utils/constants.dart';

class ScanConfirmationScreen extends StatefulWidget {
  const ScanConfirmationScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  ScanConfirmationScreenState createState() => ScanConfirmationScreenState();
}

class ScanConfirmationScreenState extends State<ScanConfirmationScreen>
    with TickerProviderStateMixin {

  late AnimationController _imageAnimationController;
  late AnimationController _initialAnimationController;
  late AnimationController _finalAnimationController;

  late Animation<double> _imageFadeInAnimation;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _resizeAnimation;
  late Animation<double> _translationAnimation;

  final _ocr = OcrService();

  final _picker = ImagePicker();
  late File _image;

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _image = File(pickedImage.path);
    }
  }

  @override
  void initState() {
    super.initState();

    _image = File(widget.imagePath);

    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _imageFadeInAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _imageAnimationController,
        curve: Curves.easeOut,
      )
    );

    _initialAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeOutAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(_initialAnimationController,);

    _translationAnimation = Tween(
      begin: 0.0,
      end: 150.0,
    ).animate(
      CurvedAnimation(
        parent: _initialAnimationController,
        curve: Curves.easeInBack,
      )
    );

    _resizeAnimation = Tween(
      begin: AppDesign.camBtnWidth + 60.0,
      end: AppDesign.camBtnWidth + 100.0,
    ).animate(
      CurvedAnimation(
        parent: _initialAnimationController,
        curve: Curves.easeInOutBack,
      )
    );

    _finalAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeInAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_finalAnimationController);
  }

  @override
  void dispose() {
    _initialAnimationController.dispose();
    _finalAnimationController.dispose();
    _ocr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RecognizedText recognizedText;
    Transaction transaction = Transaction();

    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _initialAnimationController,
              _finalAnimationController,
              _imageAnimationController,
            ]),
            builder: (context, child) {
              if (_initialAnimationController.isCompleted) {
                _finalAnimationController.forward();
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppDesign.camInnerBorderRadius),
                        child: Image.file(
                          _image,
                          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                            if (frame != null) {
                              _imageAnimationController.forward();

                              return Opacity(
                                opacity: _imageFadeInAnimation.value,
                                child: child,
                              );
                            } else {
                              // Default to a 9:16 aspect ratio when picture isn't loaded yet
                              return AspectRatio(
                                aspectRatio: 9.0/16.0,
                                child: Opacity(
                                  opacity: _imageFadeInAnimation.value,
                                  child: child,
                                ),
                              );
                            }
                          },
                        )
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Transform.translate(
                          offset: Offset(-_translationAnimation.value, 0),
                          child: Visibility(
                            visible: !_translationAnimation.isCompleted,
                            child: SizedBox(
                              width: AppDesign.camBtnWidth,
                              height: AppDesign.camBtnHeight,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.close,
                                  size: AppDesign.sBtnIconSize,
                                  color: AppDesign.appOffblack,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: _resizeAnimation.value,
                          height: AppDesign.camBtnHeight + 5.0,
                          child: GradientBorderButton(
                            onPressed: () async {
                              _initialAnimationController.forward();

                              recognizedText = await _ocr.run(widget.imagePath);
                              transaction.populateWithOcrMapper(OcrMapperService(), recognizedText);

                              print(recognizedText.text);

                              if (!context.mounted) return;

                              await Navigator.of(context).pushReplacement(
                                MaterialPageRoute<void>(
                                  builder: (context) => DataVerificationScreen(transaction: transaction)
                                )
                              );
                            },
                            gradient: LinearGradient(colors: [
                                AppDesign.primaryGradientStart,
                                AppDesign.primaryGradientEnd
                              ]),
                            borderRadius: AppDesign.sBtnBorderRadius,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Opacity(
                                  opacity: _fadeOutAnimation.value,
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "AROneSans",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Opacity(
                                  opacity: _fadeInAnimation.value,
                                  child: Text(
                                    "Processing...",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "AROneSans",
                                    ),
                                  ),
                                )
                              ]
                            ),
                          ),
                        ),

                        Transform.translate(
                          offset: Offset(_translationAnimation.value, 0),
                          child: Visibility(
                            visible: !_translationAnimation.isCompleted,
                            child: SizedBox(
                              width: AppDesign.camBtnWidth,
                              height: AppDesign.camBtnHeight,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _openImagePicker();
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.upload,
                                  size: AppDesign.sBtnIconSize,
                                  color: AppDesign.appOffblack,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          ),
        )
      ),
    );
  }
}
