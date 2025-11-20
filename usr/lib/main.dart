import 'package:flutter/material.dart';

void main() {
  runApp(const JarvisApp());
}

class JarvisApp extends StatelessWidget {
  const JarvisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JARVIS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00BCD4), // Cyan
        scaffoldBackgroundColor: const Color(0xFF050505), // Very dark grey/black
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00BCD4),
          secondary: Color(0xFF00E5FF),
          surface: Color(0xFF121212),
        ),
        fontFamily: 'Courier', // Monospaced font for tech feel
        useMaterial3: true,
      ),
      home: const JarvisHomePage(),
    );
  }
}

class JarvisHomePage extends StatefulWidget {
  const JarvisHomePage({super.key});

  @override
  State<JarvisHomePage> createState() => _JarvisHomePageState();
}

class _JarvisHomePageState extends State<JarvisHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Grid or Elements could go here
            
            // Central Interface
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pulsing Core
                  ScaleTransition(
                    scale: _animation,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00BCD4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00BCD4).withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF00BCD4).withOpacity(0.2),
                            border: Border.all(
                              color: const Color(0xFF00E5FF),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.mic_none,
                            size: 50,
                            color: Color(0xFF00E5FF),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Status Text
                  const Text(
                    "J.A.R.V.I.S.",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                      color: Color(0xFF00BCD4),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "SYSTEM ONLINE",
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 2,
                      color: const Color(0xFF00BCD4).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            
            // Corner UI Elements
            Positioned(
              top: 20,
              left: 20,
              child: _buildStatusIndicator("CPU", "NORMAL"),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: _buildStatusIndicator("NET", "CONNECTED"),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.settings, color: Color(0xFF00BCD4)),
                onPressed: () {},
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.keyboard_voice, color: Color(0xFF00BCD4)),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String label, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF00BCD4).withOpacity(0.6),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          status,
          style: const TextStyle(
            color: Color(0xFF00E5FF),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
