import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'tree_page.dart';
import 'array_page.dart';
import 'stack_page.dart';
import 'queue_page.dart';

class LinearNonLinearPage extends StatefulWidget {
  const LinearNonLinearPage({super.key});

  @override
  State<LinearNonLinearPage> createState() => _LinearNonLinearPageState();
}

class _LinearNonLinearPageState extends State<LinearNonLinearPage> {
  bool _linearExpanded = false;
  bool _nonLinearExpanded = false;

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Linear DS (LEFT aligned) ---
            Align(
              alignment: Alignment.topLeft,
              child: _buildExpandableButton(
                "LINEAR DATA STRUCTURES",
                _linearExpanded,
                () {
                  setState(() {
                    _linearExpanded = !_linearExpanded;
                  });
                },
                [
                  _buildOption(context, "ARRAY", 'assets/icons/array.svg', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ArrayPage()),
                    );
                  }),
                  _buildOption(context, "QUEUE", 'assets/icons/queue.svg', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QueuePage()),
                    );
                  }),
                  _buildOption(context, "STACK", 'assets/icons/stack.svg', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StackPage()),
                    );
                  }),
                  _buildOption(context, "LINKED LIST", 'assets/icons/linked_list.svg', () {
                   
                  },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- Non Linear DS (RIGHT aligned) ---
            Align(
              alignment: Alignment.bottomRight,
              child: _buildExpandableButton(
                "NON-LINEAR DATA STRUCTURES",
                _nonLinearExpanded,
                () {
                  setState(() {
                    _nonLinearExpanded = !_nonLinearExpanded;
                  });
                },
                [
                  _buildOption(context, "TREE", "assets/icons/tree.svg", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TreePage()),
                    );
                  }),
                  _buildOption(context, "GRAPH", "assets/icons/graph.svg", () {
                    
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Custom expandable button
  Widget _buildExpandableButton(
    String title,
    bool expanded,
    VoidCallback onTap,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 250, // Fixed width (not full screen)
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 26),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        if (expanded) ...children,
      ],
    );
  }

  // 🔹 Reusable option button
  Widget _buildOption(
    BuildContext context,
    String title,
    String svgPath,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: 200, // smaller fixed width
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              width: 24,
              height: 24,
              color: Colors.black87,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
