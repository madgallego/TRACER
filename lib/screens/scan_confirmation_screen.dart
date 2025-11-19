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

  late AnimationController _initialAnimationController;
  late AnimationController _finalAnimationController;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _resizeAnimation;

  @override
  void initState() {
    super.initState();

    _initialAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeOutAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(_initialAnimationController,);

    _resizeAnimation = Tween(
      begin: AppDesign.camBtnWidth + 60.0,
      end: AppDesign.camBtnWidth + 100.0,
    ).animate(_initialAnimationController);

    _finalAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
          child: Column(
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
                    child: Image.file(File(widget.imagePath))
                  ),
                ),
              ),

              const SizedBox(
                height: 10.0,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _initialAnimationController,
                    _finalAnimationController
                  ]),
                  builder: (context, child) {
                    if (_initialAnimationController.isCompleted) {
                      _finalAnimationController.forward();
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: _fadeOutAnimation.value != 0.0,
                          child: Opacity(
                            opacity: _fadeOutAnimation.value,
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

                        Visibility(
                          visible: _fadeOutAnimation.value != 0.0,
                          child: Opacity(
                            opacity: _fadeOutAnimation.value,
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
                    );
                  }
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
