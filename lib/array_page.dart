import 'package:flutter/material.dart';
import 'dart:async';

class ArrayPage extends StatefulWidget {
  const ArrayPage({super.key});

  @override
  State<ArrayPage> createState() => _ArrayPageState();
}

class _ArrayPageState extends State<ArrayPage> {
  List<int> arr = [4, 12, 7, 15, 9];
  int currentIndex = -1; // pointer starts before the first element
  Timer? timer;

  void startVisualization() {
    currentIndex = -1;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (currentIndex < arr.length - 1) {
          currentIndex++;
        } else {
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
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
          children: [
            // Top box with ARRAY label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: List.generate(4, (i) {
                    return Container(
                      margin: const EdgeInsets.all(2),
                      width: 35,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.grey.shade300,
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Text(
                    "ARRAY",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),

            // Description text
            const Text(
              "An array is a sequential collection of elements of same data type and stores data elements in a continuous memory location. "
              "The elements of an array are accessed by using an index. The index of an array of size N can range from 0 to N-1.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            // Array elements row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(arr.length, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade200,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    "${arr[i]}",
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }),
            ),

            // Pointer row
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(arr.length, (i) {
                return Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: currentIndex == i
                      ? const Text("↑",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold))
                      : const SizedBox.shrink(),
                );
              }),
            ),

            // Index row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(arr.length, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 50,
                  alignment: Alignment.center,
                  child: Text(
                    "$i",
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }),
            ),

            const Spacer(),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: startVisualization,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(120, 45),
                  ),
                  child: const Text("Visualize"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add "Try Yourself" logic
                  },
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
}
