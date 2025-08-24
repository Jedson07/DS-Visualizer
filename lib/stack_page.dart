import 'package:flutter/material.dart';

class StackPage extends StatefulWidget {
  const StackPage({super.key});

  @override
  State<StackPage> createState() => _StackPageState();
}

class _StackPageState extends State<StackPage> {
  final List<int> _stack = [];
  final TextEditingController _controller = TextEditingController();
  String _message = "";
  final int _maxSize = 7; // Fixed size stack

  void _push() {
    if (_controller.text.isEmpty) {
      setState(() => _message = "Enter a number to push!");
      return;
    }
    final value = int.tryParse(_controller.text);
    if (value == null) {
      setState(() => _message = "Please enter a valid integer!");
      return;
    }
    if (_controller.text.length > 10) {
      setState(() => _message = "Value should not exceed 10 digits!");
      _controller.clear();
      return;
    }
    if (_stack.length >= _maxSize) {
      setState(() {
        _message =
            "STACK OVERFLOW: Cannot insert more than $_maxSize elements!";
      });
      _controller.clear();
      return;
    }

    setState(() {
      _stack.add(value);
      _controller.clear();
      _message = "PUSH: Inserted $value at the TOP";
    });
  }

  void _pop() {
    if (_stack.isEmpty) {
      setState(() => _message = "STACK UNDERFLOW: Stack is empty, cannot pop!");
      return;
    }
    final removed = _stack.removeLast();
    setState(() {
      _message = "POP: Removed $removed from the TOP";
    });
  }

  void _peek() {
    if (_stack.isEmpty) {
      setState(() => _message = "Stack is empty, nothing to peek!");
      return;
    }
    setState(() {
      _message = "PEEK: Top element is ${_stack.last}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A4F),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          "Stack Visualizer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF0A0A4F)),
              child: Text(
                "📘 Stack Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Pseudocode
            ExpansionTile(
              leading: const Icon(Icons.code),
              title: const Text("Pseudo Code"),
              children: const [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "PUSH(x):\n"
                    "  if isFull(stack) → OVERFLOW\n"
                    "  else:\n"
                    "    top ← top + 1\n"
                    "    stack[top] ← x\n\n"
                    "POP():\n"
                    "  if isEmpty(stack) → UNDERFLOW\n"
                    "  else:\n"
                    "    return stack[top]\n"
                    "    top ← top - 1\n\n"
                    "PEEK():\n"
                    "  if isEmpty(stack) → return null\n"
                    "  else → return stack[top]",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),

            // Time Complexity
            ExpansionTile(
              leading: const Icon(Icons.timer),
              title: const Text("Time Complexity"),
              children: const [
                ListTile(
                  title: Text(
                    "PUSH → O(1)\n"
                    "POP → O(1)\n"
                    "PEEK → O(1)\n"
                    "isEmpty → O(1)\n"
                    "isFull → O(1)",
                  ),
                ),
              ],
            ),

            // Applications
            ExpansionTile(
              leading: const Icon(Icons.apps),
              title: const Text("Applications"),
              children: const [
                ListTile(
                  title: Text("👉 Expression Evaluation (Postfix/Infix)"),
                ),
                ListTile(title: Text("👉 Undo/Redo operations in editors")),
                ListTile(title: Text("👉 Function call stack in recursion")),
                ListTile(title: Text("👉 Balanced Parentheses checking")),
              ],
            ),
          ],
        ),
      ),

      // 🔹 Body (your stack visualizer UI)
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter value",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _push,
                  child: const Text("PUSH"),
                ),
                ElevatedButton(
                  onPressed: _pop,            
                  child: const Text("POP"),
                ),
                ElevatedButton(
                  onPressed: _peek,
                  child: const Text("PEEK"),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Center(
                child: _stack.isEmpty
                    ? const Text(
                        "Stack is Empty\n(Push to add elements)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: List.generate(_stack.length, (i) {
                              if (i == 0) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: const Text(
                                    "TOP → ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox(height: 50);
                              }
                            }),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: _stack.reversed
                                .toList()
                                .asMap()
                                .entries
                                .map((entry) {
                                  final index = entry.key;
                                  final value = entry.value;
                                  final isTop = index == 0;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: isTop
                                          ? Colors.amber.shade300
                                          : Colors.white,
                                      border: Border.all(
                                        color: isTop
                                            ? Colors.blue.shade900
                                            : Colors.black87,
                                        width: isTop ? 2.5 : 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        value.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: isTop
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: isTop
                                              ? Colors.blue.shade900
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              "Note: Stack follows LIFO (Last In, First Out)\n"
              "- PUSH adds at the TOP\n- POP removes from the TOP\n- PEEK shows the TOP element\n"
              "- Max size = 7 (overflow if exceeded)",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
