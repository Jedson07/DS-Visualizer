import 'package:flutter/material.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Graph sketch with 4 nodes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    _node("A"),
                    const SizedBox(height: 20),
                    _node("D"),
                  ],
                ),
                const SizedBox(width: 40),
                Column(
                  children: [
                    _node("B"),
                    const SizedBox(height: 20),
                    _node("C"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "GRAPH",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "A graph is a collection of nodes (vertices) connected by edges. "
              "Graphs can be directed or undirected, weighted or unweighted. "
              "They are widely used to represent relationships such as networks, "
              "maps, and social connections.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(120, 45),
                  ),
                  child: const Text("Visualize"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(120, 45),
                  ),
                  child: const Text("Try Yourself"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _node(String label) {
    return Container(
      width: 50,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
