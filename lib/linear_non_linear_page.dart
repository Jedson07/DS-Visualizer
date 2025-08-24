import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'tree_page.dart';
import 'array_page.dart';
import 'stack_page.dart';

class LinearNonLinearPage extends StatelessWidget {
  const LinearNonLinearPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16), // top spacing

            // --- Linear DS Section Heading ---
            _buildGradientHeading("LINEAR DATA STRUCTURES"),

            // linear options (no extra spacing before them)
            _buildOption(context, "ARRAY", 'assets/icons/array.svg', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ArrayPage()),
              );
            }),
            const SizedBox(height: 10),
            _buildOption(context, "QUEUE", 'assets/icons/queue.svg', () {}),
            const SizedBox(height: 10),
            _buildOption(context, "STACK", 'assets/icons/stack.svg', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StackPage()),
              );
            }),
            const SizedBox(height: 10),
            _buildOption(
                context, "LINKED LIST", 'assets/icons/linked_list.svg', () {}),

            const SizedBox(height: 32), // spacing ONLY before Non-Linear

            // --- Non Linear DS Section Heading ---
            _buildGradientHeading("NON-LINEAR DATA STRUCTURES"),

            // non-linear options
            _buildOption(context, "TREE", "assets/icons/tree.svg", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TreePage()),
              );
            }),
            const SizedBox(height: 10),
            _buildOption(context, "GRAPH", "assets/icons/graph.svg", () {
              // TODO: Navigate to Graph page later
            }),
          ],
        ),
      ),
    );
  }

  // Gradient heading button
  Widget _buildGradientHeading(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12), // slight breathing room
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  // Reusable option button
  Widget _buildOption(
      BuildContext context, String title, String svgPath, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4), // keeps spacing uniform
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
        child: Row(
          children: [
            SvgPicture.asset(svgPath,
                width: 26, height: 26, color: Colors.black87),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
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
