import 'dart:async';
import 'dart:math';
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
          onSurface: Color(0xFFE0F7FA),
        ),
        fontFamily: 'Courier', // Monospaced font for tech feel
        useMaterial3: true,
        cardTheme: CardTheme(
          color: const Color(0xFF121212).withOpacity(0.8),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFF00BCD4), width: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const JarvisDashboard(),
    );
  }
}

class JarvisDashboard extends StatefulWidget {
  const JarvisDashboard({super.key});

  @override
  State<JarvisDashboard> createState() => _JarvisDashboardState();
}

class _JarvisDashboardState extends State<JarvisDashboard> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final ScrollController _logScrollController = ScrollController();
  final TextEditingController _cmdController = TextEditingController();
  
  String _userStatus = "ID: SCANNING...";
  
  // Mock Data for "Processing"
  final List<String> _systemLogs = [
    "Initializing core systems...",
    "Connecting to satellite network...",
    "System integrity: 100%",
  ];

  final List<Map<String, dynamic>> _activeModules = [
    {"name": "SECURITY", "status": "ARMED", "icon": Icons.shield_outlined, "progress": 1.0},
    {"name": "NETWORK", "status": "ONLINE", "icon": Icons.wifi, "progress": 0.98},
    {"name": "POWER", "status": "STABLE", "icon": Icons.bolt, "progress": 0.85},
    {"name": "AI CORE", "status": "LEARNING", "icon": Icons.psychology, "progress": 0.45},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Simulate incoming logs
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _addLogEntry(_generateRandomLog());
        });
      }
    });
    
    // Initiate Identity Verification
    Future.delayed(const Duration(seconds: 1), _verifyIdentity);
  }

  void _verifyIdentity() {
    if (!mounted) return;
    setState(() {
      _addLogEntry("Initiating biometric scan...");
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _addLogEntry("Retinal match confirmed.");
        _addLogEntry("Identity verified: CREATOR.");
        _addLogEntry("Welcome back, Sir.");
        _userStatus = "ID: CREATOR";
      });
    });
  }

  String _generateRandomLog() {
    final actions = ["Scanning", "Processing", "Optimizing", "Encrypting", "Analyzing"];
    final targets = ["Data Packets", "Neural Net", "Security Protocol", "User Input", "Cloud Storage"];
    final random = Random();
    return "${actions[random.nextInt(actions.length)]} ${targets[random.nextInt(targets.length)]}...";
  }

  void _addLogEntry(String log) {
    _systemLogs.add("${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second} - $log");
    if (_systemLogs.length > 20) _systemLogs.removeAt(0);
    
    // Auto scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollController.hasClients) {
        _logScrollController.animateTo(
          _logScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  void _processCommand(String command) {
    _cmdController.clear();
    setState(() {
      _addLogEntry("USER CMD: $command");
      
      final lowerValue = command.toLowerCase();
      if (lowerValue.contains("who am i") || 
          lowerValue.contains("creator") || 
          lowerValue.contains("do you know me") ||
          lowerValue.contains("identify user")) {
         
         _addLogEntry("PROCESSING: Analyzing voice print...");
         Future.delayed(const Duration(milliseconds: 1500), () {
           if(mounted) {
             setState(() {
               _addLogEntry("RESPONSE: You are the Creator.");
               _addLogEntry("Access Level: OMNIPOTENT.");
               _addLogEntry("All systems are at your command, Sir.");
             });
           }
         });
      } else if (lowerValue.contains("hello") || lowerValue.contains("hi")) {
         _addLogEntry("RESPONSE: Greetings, Sir.");
      } else {
         _addLogEntry("Processing command...");
         Future.delayed(const Duration(seconds: 1), () {
           if(mounted) {
             setState(() {
               _addLogEntry("Command executed successfully.");
             });
           }
         });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _logScrollController.dispose();
    _cmdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Grid Effect
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  const Color(0xFF051518),
                  const Color(0xFF000000),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Row(
                    children: [
                      // Left Panel: System Modules
                      Expanded(
                        flex: 3,
                        child: _buildModulesGrid(),
                      ),
                      // Right Panel: Core & Logs
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildCoreVisualizer(),
                            Expanded(child: _buildLogTerminal()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.memory, color: Color(0xFF00BCD4)),
              const SizedBox(width: 10),
              Text(
                "J.A.R.V.I.S. // DASHBOARD",
                style: TextStyle(
                  color: const Color(0xFF00BCD4),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 16,
                  shadows: [
                    Shadow(color: const Color(0xFF00BCD4).withOpacity(0.5), blurRadius: 10),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF00BCD4).withOpacity(0.3)),
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFF00BCD4).withOpacity(0.1),
            ),
            child: Text(
              _userStatus,
              style: TextStyle(
                color: _userStatus.contains("CREATOR") ? const Color(0xFF00E5FF) : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModulesGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _activeModules.length,
      itemBuilder: (context, index) {
        final module = _activeModules[index];
        return _buildModuleCard(module);
      },
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module) {
    return Card(
      elevation: 4,
      color: const Color(0xFF0A1A1C).withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(module['icon'], color: const Color(0xFF00BCD4), size: 28),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF00BCD4).withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    module['status'],
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF00E5FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              module['name'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 5),
            LinearProgressIndicator(
              value: module['progress'],
              backgroundColor: const Color(0xFF003333),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00BCD4)),
            ),
            const SizedBox(height: 5),
            Text(
              "Load: ${(module['progress'] * 100).toInt()}%",
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoreVisualizer() {
    return SizedBox(
      height: 200,
      child: Center(
        child: ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF00BCD4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00BCD4).withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF00BCD4).withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.fingerprint,
                size: 60,
                color: Color(0xFF00E5FF),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogTerminal() {
    return Container(
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF050505),
        border: Border.all(color: const Color(0xFF00BCD4).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "> SYSTEM LOGS",
            style: TextStyle(
              color: Color(0xFF00BCD4),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const Divider(color: Color(0xFF00BCD4), height: 20),
          Expanded(
            child: ListView.builder(
              controller: _logScrollController,
              itemCount: _systemLogs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    _systemLogs[index],
                    style: TextStyle(
                      color: const Color(0xFF00E5FF).withOpacity(0.7),
                      fontSize: 10,
                      fontFamily: 'Courier',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: const Color(0xFF00BCD4).withOpacity(0.3))),
        color: const Color(0xFF0A0A0A),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF00BCD4).withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.terminal, size: 16, color: Color(0xFF00BCD4)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _cmdController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: "Enter command...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onSubmitted: _processCommand,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              setState(() {
                _addLogEntry("Voice command initiated...");
              });
            },
            icon: const Icon(Icons.mic, color: Color(0xFF00BCD4)),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF00BCD4).withOpacity(0.1),
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
