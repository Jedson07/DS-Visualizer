import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart'; // Import HomePage

void main() {
  runApp(const DSVisualizerApp());
}

class DSVisualizerApp extends StatelessWidget {
  const DSVisualizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DS Visualizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0A0A4F),
      ),
      home: const SplashPage(),
    );
  }
}

// ------------------- SPLASH PAGE -------------------
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int activeDot = 0;
  Timer? dotTimer;

  @override
  void initState() {
    super.initState();

    // Cycle through dots every 400ms
    dotTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        activeDot = (activeDot + 1) % 3; // Loop between 0,1,2
      });
    });

    // After 3 seconds go to HomePage
    Timer(const Duration(seconds: 3), () {
      dotTimer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  void dispose() {
    dotTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // White Tree
            CustomPaint(
              size: const Size(150, 150),
              painter: TreePainter(
                nodeColor: Colors.white,
                lineColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "DS Visualizer",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              "Learn by Seeing",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),

            // Animated dots row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  height: 10,
                  width: activeDot == index ? 20 : 10,
                  decoration: BoxDecoration(
                    color: activeDot == index ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
