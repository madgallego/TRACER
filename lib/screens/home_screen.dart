import 'package:flutter/material.dart';
import 'package:tracer/screens/scan_screen.dart';
import 'package:tracer/screens/settings_screen.dart';
import 'package:tracer/utils/constants.dart';
import 'package:tracer/widgets/gradient_border_button.dart';
import 'package:tracer/widgets/gradient_border_text.dart';
import 'package:tracer/widgets/gradient_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeLogo;
  late Animation<double> _scaleLogo;
  late Animation<double> _fadeButtons;
  late Animation<double> _translateButtons;


  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeLogo = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _scaleLogo = Tween(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _fadeButtons = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    _translateButtons = Tween(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF62D2F5), // Light blue
              Color(0xFFFFFE6A), // Light Yellow
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)
                )
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),

                          //header logo
                          Opacity(
                            opacity: _fadeLogo.value,
                            child: Transform.scale(
                              scale: _scaleLogo.value,
                              child: GradientBorderText(
                                text: "TRACER",
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 90,
                                  fontFamily: 'Iceland',
                                  // fontWeight: FontWeight.w700,
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    AppDesign.primaryGradientStart,
                                    AppDesign.primaryGradientEnd
                                  ]
                                ),
                                strokeWidth: 12.0,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(0, 10.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // main buttons
                          Transform.translate(
                            offset: Offset(0, _translateButtons.value),
                            child: Opacity(
                              opacity: _fadeButtons.value,
                              child: Column(
                                children: [

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _HomeRoundedButton(
                                        gradientIcon: GradientIcon(
                                          icon: Icons.folder_open,
                                          size: 24.0,
                                          gradient: LinearGradient(
                                            colors: [
                                              AppDesign.primaryGradientStart,
                                              AppDesign.primaryGradientEnd,
                                            ]
                                          )
                                        ),
                                        title: "Records",
                                        onTap: () {
                                          // TODO: navigate to records screen
                                        },
                                      ),
                                      _HomeRoundedButton(
                                        gradientIcon: GradientIcon(
                                          icon: Icons.settings,
                                          size: 24.0,
                                          gradient: LinearGradient(
                                            colors: [
                                              AppDesign.primaryGradientStart,
                                              AppDesign.primaryGradientEnd,
                                            ]
                                          )
                                        ),
                                        title: "Settings",
                                        onTap: () async {
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => SettingsScreen())
                                          );
                                        },
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 25),

                                  GradientBorderButton(
                                    onPressed: () async {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => ScanScreen())
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(30.0),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppDesign.primaryGradientStart,
                                        AppDesign.primaryGradientEnd
                                      ]
                                    ),
                                    child: Column(
                                      children: [
                                        GradientIcon(
                                          icon: Icons.camera_alt_outlined,
                                          size: 48.0,
                                          gradient: LinearGradient(
                                            colors: [
                                              AppDesign.primaryGradientStart,
                                              AppDesign.primaryGradientEnd,
                                            ]
                                          ),
                                        ),
                                        const Text(
                                          "Scanner",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: AppDesign.appOffblack,
                                            fontFamily: "AROneSans",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ]
                                    ),
                                  ),

                                  const SizedBox(height: 75),

                                  _LinkTile(
                                    title: "About this App",
                                    onTap: (){
                                      Navigator.pushNamed(context, "/howto");
                                    },
                                  )

                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Button widgets
class _HomeRoundedButton extends StatelessWidget{
  final GradientIcon gradientIcon;
  final String title;
  final VoidCallback onTap;

  const _HomeRoundedButton({
    required this.gradientIcon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context){
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      shadowColor: Colors.black,
      elevation: 1.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: SizedBox(
          width: 145,
          height: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              gradientIcon,
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                  color: AppDesign.appOffblack,
                  fontFamily: "AROneSans",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget{
  final String title;
  final VoidCallback onTap;

  const _LinkTile({
    required this.title,
    required this.onTap,

  });

  @override

  Widget build(BuildContext context){
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 1.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
              children:[
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: AppDesign.appOffblack,
                      fontFamily: "AROneSans",
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ),
                const Icon(Icons.open_in_new, size: 18),
              ]
          ),
        ),
      ),
    );
  }
}
