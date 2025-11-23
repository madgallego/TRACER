import 'package:flutter/material.dart';

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
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      const SizedBox(height: 35),
                    
  
                    //header logo
                    Opacity(
                      opacity: _fadeLogo.value,
                      child: Transform.scale(
                        scale: _scaleLogo.value,
                        child: Text(
                          "TRACER",
                          style: TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [
                                  Color(0xFF9CF3FF),
                                  Color(0xFFEFFFA3),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(const Rect.fromLTWH(0, 0, 200, 80))
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
  
                    //main buttons
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
                                  icon: Icons.folder_open,
                                  title: "Records",
                                  onTap: () {
                                    Navigator.pushNamed(context, '/records');
                                  },
                                ),
                              _HomeRoundedButton(
                                icon: Icons.settings,
                                title: "Settings",
                                onTap: (){
                                  Navigator.pushNamed(context, "/settings");
                                },
                              ),
                              ],
                            ),

                          const SizedBox(height: 25),
                          
                            _ScannerButton(
                              onTap:(){
                                Navigator.pushNamed(context, "/scanner");
                              },
                            ),

                            const SizedBox(height: 25),

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
    );
    
  
  }
}

//Button widgets
class _HomeRoundedButton extends StatelessWidget{
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _HomeRoundedButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context){
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: 145,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(2,2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
class _ScannerButton extends StatelessWidget{
  final VoidCallback onTap;

  const _ScannerButton({required this.onTap});

  @override
  Widget build(BuildContext context){
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        height: 95,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
        ),
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt_outlined, color: Colors.black54),
                SizedBox(width: 6),
                Text(
                  "Scanner",
                  style: TextStyle(fontSize: 16),
                )
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
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
              children:[
                Expanded(child: Text(title)),
                const Icon(Icons.open_in_new, size: 18),
              ]
          ),
        ),
      ),
    );
  }
}
