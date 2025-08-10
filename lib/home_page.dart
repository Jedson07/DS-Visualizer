import 'package:flutter/material.dart';

// ------------------- HOME PAGE -------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A4F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    "WELCOME TO",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "DS Visualizer",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A0A4F),
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomPaint(
                    size: const Size(100, 100),
                    painter: TreePainter(
                      nodeColor: const Color(0xFF0A0A4F),
                      lineColor: const Color(0xFF0A0A4F),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.arrow_forward, color: Colors.black87),
              label: const Text(
                "Start Simulator",
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
              onPressed: () {
                // TODO: Navigate to simulator page
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------- TREE PAINTER -------------------
class TreePainter extends CustomPainter {
  final Color nodeColor;
  final Color lineColor;

  TreePainter({required this.nodeColor, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = lineColor
      ..strokeWidth = 3;

    final paintNode = Paint()..color = nodeColor;

    final centerTop = Offset(size.width / 2, size.height * 0.2);
    final leftMid = Offset(size.width * 0.3, size.height * 0.5);
    final rightMid = Offset(size.width * 0.7, size.height * 0.5);
    final leftBottom = Offset(size.width * 0.2, size.height * 0.8);
    final midBottom = Offset(size.width * 0.5, size.height * 0.8);
    final rightBottom = Offset(size.width * 0.8, size.height * 0.8);

    canvas.drawLine(centerTop, leftMid, paintLine);
    canvas.drawLine(centerTop, rightMid, paintLine);
    canvas.drawLine(leftMid, leftBottom, paintLine);
    canvas.drawLine(leftMid, midBottom, paintLine);
    canvas.drawLine(rightMid, rightBottom, paintLine);

    for (var point in [
      centerTop,
      leftMid,
      rightMid,
      leftBottom,
      midBottom,
      rightBottom
    ]) {
      canvas.drawCircle(point, 10, paintNode);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
