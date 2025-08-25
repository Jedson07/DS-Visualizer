import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ for Clipboard

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

  // ✅ Added: language -> source mapping
  final Map<String, String> _sourceByLang = const {
    'Python': r'''
MAX = 7

class Stack:
    def __init__(self):
        self.data = []

    def is_empty(self):
        return len(self.data) == 0

    def is_full(self):
        return len(self.data) >= MAX

    def push(self, x):
        if self.is_full():
            raise OverflowError("STACK OVERFLOW")
        self.data.append(x)

    def pop(self):
        if self.is_empty():
            raise IndexError("STACK UNDERFLOW")
        return self.data.pop()

    def peek(self):
        if self.is_empty():
            return None
        return self.data[-1]

if __name__ == "__main__":
    s = Stack()
    s.push(10); s.push(20); s.push(30)
    print("Top:", s.peek())
    print("Pop:", s.pop())
    print("Top after pop:", s.peek())
''',
    'C': r'''
#include <stdio.h>
#define MAX 7

int stack[MAX];
int top = -1;

int isEmpty() { return top == -1; }
int isFull()  { return top == MAX - 1; }

void push(int x) {
    if (isFull()) { printf("STACK OVERFLOW\n"); return; }
    stack[++top] = x;
}

int pop() {
    if (isEmpty()) { printf("STACK UNDERFLOW\n"); return -1; }
    return stack[top--];
}

int peek() {
    if (isEmpty()) { return -1; }
    return stack[top];
}

int main() {
    push(10); push(20); push(30);
    printf("Top: %d\n", peek());
    printf("Pop: %d\n", pop());
    printf("Top after pop: %d\n", peek());
    return 0;
}
''',
    'C++': r'''
#include <bits/stdc++.h>
using namespace std;

struct Stack {
    static const int MAX = 7;
    vector<int> a;
    bool empty() const { return a.empty(); }
    bool full()  const { return (int)a.size() >= MAX; }
    void push(int x) {
        if (full()) { cout << "STACK OVERFLOW\n"; return; }
        a.push_back(x);
    }
    int pop() {
        if (empty()) { cout << "STACK UNDERFLOW\n"; return -1; }
        int v = a.back(); a.pop_back(); return v;
    }
    int peek() const { return empty() ? -1 : a.back(); }
};

int main() {
    Stack s;
    s.push(10); s.push(20); s.push(30);
    cout << "Top: " << s.peek() << "\n";
    cout << "Pop: " << s.pop() << "\n";
    cout << "Top after pop: " << s.peek() << "\n";
    return 0;
}
''',
    'Java': r'''
public class StackDemo {
    static class IntStack {
        private static final int MAX = 7;
        private final int[] a = new int[MAX];
        private int top = -1;

        boolean isEmpty() { return top == -1; }
        boolean isFull()  { return top == MAX - 1; }

        void push(int x) {
            if (isFull()) { System.out.println("STACK OVERFLOW"); return; }
            a[++top] = x;
        }

        int pop() {
            if (isEmpty()) { System.out.println("STACK UNDERFLOW"); return -1; }
            return a[top--];
        }

        int peek() { return isEmpty() ? -1 : a[top]; }
    }

    public static void main(String[] args) {
        IntStack s = new IntStack();
        s.push(10); s.push(20); s.push(30);
        System.out.println("Top: " + s.peek());
        System.out.println("Pop: " + s.pop());
        System.out.println("Top after pop: " + s.peek());
    }
}
''',
  };

  // ✅ Added: selected language for dialog
  String _selectedLang = 'Python';

  // ✅ Added: source code dialog
  void _showSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Stack Source Code"),
              content: SizedBox(
                width:
                    MediaQuery.of(context).size.width *0.8, // 🔹 increased width
                height:
                    MediaQuery.of(context).size.height *0.6, // 🔹 scaled height
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final lang in _sourceByLang.keys)
                          ChoiceChip(
                            label: Text(lang),
                            selected: _selectedLang == lang,
                            onSelected: (v) {
                              if (v) setStateDialog(() => _selectedLang = lang);
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade50,
                        ),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            _sourceByLang[_selectedLang] ?? '',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text("Copy"),
                  onPressed: () async {
                    final code = _sourceByLang[_selectedLang] ?? '';
                    await Clipboard.setData(ClipboardData(text: code));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Copied $_selectedLang code to clipboard",
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

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

  void _refresh() {
    setState(() {
      _stack.clear(); // clear the stack
      _message = ""; // reset message
      _controller.clear(); // clear input field
    });
  }

  Widget _buildNote() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 10,
      ), // reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "NOTE:\n"
        "1. PUSH → Insert element at TOP of the stack.\n"
        "2. POP → Remove element from TOP of the stack.\n"
        "3. PEEK → Shows the TOP element without removing it.\n"
        "4. Stack follows LIFO (Last In, First Out) principle.\n"
        "5. Maximum stack size = 7 (Overflow occurs if exceeded).",
        style: TextStyle(fontSize: 14),
      ),
    );
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
          "Stack Visualizer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // 🔄 Refresh button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refresh,
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
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

            // ✅ NEW: Source Code option
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text("Source Code"),
              onTap: () {
                Navigator.pop(context);
                _showSourceDialog();
              },
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

      //  Body (your stack visualizer UI)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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

            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _push, child: const Text("PUSH")),
                ElevatedButton(onPressed: _pop, child: const Text("POP")),
                ElevatedButton(onPressed: _peek, child: const Text("PEEK")),
              ],
            ),

            const SizedBox(height: 1),
            Text(
              _message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Wrap the stack visualization in ConstrainedBox to avoid overflow
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.38,
              ),
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
                                return const SizedBox(height: 31);
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
                                      vertical: 1,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    height: 30,
                                    width: 120,
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

            const SizedBox(height: 70),
            _buildNote(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
