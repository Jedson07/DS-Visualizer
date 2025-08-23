import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LinearDSPage extends StatelessWidget {
  const LinearDSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A4F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "DS Visualizer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOption(context, "ARRAY", 'assets/icons/array.svg', () {
              // TODO: Navigate to Array visualization
            }),
            const SizedBox(height: 20),
            _buildOption(context, "QUEUE", 'assets/icons/queue.svg', () {
              // TODO: Navigate to Queue visualization
            }),
            const SizedBox(height: 20),
            _buildOption(context, "STACK", 'assets/icons/stack.svg', () {
              // TODO: Navigate to Stack visualization
            }),
            const SizedBox(height: 20),
            _buildOption(context, "LINKED LIST", 'assets/icons/linked_list.svg', () {
              // TODO: Navigate to Linked List visualization
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, String title, String svgPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            SvgPicture.asset(svgPath, width: 40, height: 40, color: Colors.black87),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
