import 'dart:io';

import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          File(widget.imagePath),
                          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                            if (frame != null) {
                              _imageAnimationController.forward();
                            }

                            return AspectRatio(
                              aspectRatio: 9.0/16.0,
                              child: Opacity(
                                opacity: _imageFadeInAnimation.value,
                                child: child,
                              ),
                            );
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

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  overlayColor: Colors.black,
                                  padding: EdgeInsets.zero,
                                ),
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
                                    ),
                                  ),
                                ),

                                Opacity(
                                  opacity: _fadeInAnimation.value,
                                  child: Text(
                                    "Processing...",
                                    style: TextStyle(
                                      fontSize: 18.0,
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
                                onPressed: () {

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  overlayColor: Colors.black,
                                  padding: EdgeInsets.zero,
                                ),
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
