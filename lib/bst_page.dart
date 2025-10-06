import 'package:flutter/material.dart';
import 'dart:math';

// ------------------ NODE MODEL ------------------
class BSTNode {
  int value;
  BSTNode? left;
  BSTNode? right;
  BSTNode(this.value);
}

// ------------------ MAIN BST PAGE ------------------
class BSTPage extends StatefulWidget {
  const BSTPage({super.key});

  @override
  State<BSTPage> createState() => _BSTPageState();
}

class _BSTPageState extends State<BSTPage> {
  BSTNode? root;
  final TextEditingController _controller = TextEditingController();
  String message = "";

  bool isAnimating = false;
  List<BSTNode> highlightedNodes = [];
  BSTNode? targetNode;

  // ------------------ INSERT / DELETE / SEARCH ------------------
  Future<void> insertAnimated(int value) async {
    if (isAnimating) return;
    isAnimating = true;
    highlightedNodes.clear();
    targetNode = null;

    root = await _insertAnimated(root, value);
    message = "Inserted $value";

    highlightedNodes.clear();
    targetNode = null;
    setState(() {});
    isAnimating = false;
  }

  Future<BSTNode> _insertAnimated(BSTNode? node, int value) async {
    if (node == null) {
      BSTNode newNode = BSTNode(value);
      targetNode = newNode;
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 700));
      return newNode;
    }

    highlightedNodes = [node];
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 700));

    if (value < node.value) {
      node.left = await _insertAnimated(node.left, value);
    } else if (value > node.value) {
      node.right = await _insertAnimated(node.right, value);
    }
    return node;
  }

  Future<void> searchAnimated(int value) async {
    if (isAnimating || root == null) return;
    isAnimating = true;
    highlightedNodes.clear();
    targetNode = null;

    BSTNode? found = await _searchAnimated(root, value);

    if (found != null) {
      targetNode = found;
      message = "Found $value";
    } else {
      message = "Value $value not found";
    }

    highlightedNodes.clear();
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 700));
    targetNode = null;
    isAnimating = false;

    
  }

  Future<BSTNode?> _searchAnimated(BSTNode? node, int value) async {
    if (node == null) return null;
    highlightedNodes = [node];
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 700));

    if (node.value == value) return node;
    if (value < node.value) return await _searchAnimated(node.left, value);
    return await _searchAnimated(node.right, value);
  }

  Future<void> deleteAnimated(int value) async {
    if (isAnimating || root == null) return;
    isAnimating = true;
    highlightedNodes.clear();
    targetNode = null;

    root = await _deleteAnimated(root, value);
    message = "Deleted $value";

    highlightedNodes.clear();
    targetNode = null;
    setState(() {});
    isAnimating = false;
  }

  Future<BSTNode?> _deleteAnimated(BSTNode? node, int value) async {
    if (node == null) return null;

    highlightedNodes = [node];
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 700));

    if (value < node.value) {
      node.left = await _deleteAnimated(node.left, value);
    } else if (value > node.value) {
      node.right = await _deleteAnimated(node.right, value);
    } else {
      targetNode = node;
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 700));

      if (node.left == null) return node.right;
      if (node.right == null) return node.left;

      BSTNode minNode = _findMin(node.right!);
      node.value = minNode.value;
      node.right = await _deleteAnimated(node.right, minNode.value);
    }
    return node;
  }

  BSTNode _findMin(BSTNode node) {
    while (node.left != null) node = node.left!;
    return node;
  }
  
  // ------------------ TRAVERSALS ------------------
  Future<void> _traverseAnimated(String type) async {
  if (root == null || isAnimating) return;
  isAnimating = true;
  highlightedNodes.clear();
  targetNode = null;

  List<BSTNode> traversal = [];
  switch (type) {
    case 'Inorder':
      _inorder(root, traversal);
      break;
    case 'Preorder':
      _preorder(root, traversal);
      break;
    case 'Postorder':
      _postorder(root, traversal);
      break;
  }

  List<int> visitedValues = [];
  message = "🔄 $type Traversal in progress...";
  setState(() {});

  for (var node in traversal) {
    highlightedNodes = [node];
    visitedValues.add(node.value);
    setState(() {
      message = "$type Traversal: ${visitedValues.join(', ')}";
    });
    await Future.delayed(const Duration(milliseconds: 700));
  }

  highlightedNodes.clear();
  
  setState(() {});
  isAnimating = false;
}
  void _inorder(BSTNode? node, List<BSTNode> res) {
    if (node == null) return;
    _inorder(node.left, res);
    res.add(node);
    _inorder(node.right, res);
  }

  void _preorder(BSTNode? node, List<BSTNode> res) {
    if (node == null) return;
    res.add(node);
    _preorder(node.left, res);
    _preorder(node.right, res);
  }

  void _postorder(BSTNode? node, List<BSTNode> res) {
    if (node == null) return;
    _postorder(node.left, res);
    _postorder(node.right, res);
    res.add(node);
  }
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

  // ------------------ UI ------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A4F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "BST Visualizer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: "Reset Tree",
            onPressed: () {
              setState(() {
                root = null;
                highlightedNodes.clear();
                targetNode = null;
                _controller.clear();
                message = "";
              });
            },
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

            //  NEW: Source Code option
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


      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Enter value",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {
                  final val = int.tryParse(_controller.text.trim());
                  if (val == null) {
                    setState(() => message = "Enter valid integer to insert");
                    return;
                  }
                  insertAnimated(val);
                  _controller.clear();
                },
                child: const Text("INSERT"),
              ),
              ElevatedButton(
                onPressed: () {
                  final val = int.tryParse(_controller.text.trim());
                  if (val == null) {
                    setState(() => message = "Enter valid integer to delete");
                    return;
                  }
                  deleteAnimated(val);
                  _controller.clear();
                },
                child: const Text("DELETE"),
              ),
              ElevatedButton(
                onPressed: () {
                  final val = int.tryParse(_controller.text.trim());
                  if (val == null) {
                    setState(() => message = "Enter valid integer to search");
                    return;
                  }
                  searchAnimated(val);
                  _controller.clear();
                },
                child: const Text("SEARCH"),
              ),
              ElevatedButton(
                onPressed: () => _traverseAnimated("Preorder"),
                child: const Text("PREORDER"),
              ),
              ElevatedButton(
                 onPressed: () => _traverseAnimated("Inorder"),
                child: const Text("INORDER"),
              ),
              ElevatedButton(
                onPressed: () => _traverseAnimated("Postorder"),
                child: const Text("POSTORDER"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              color: Colors.grey.shade300,
              width: double.infinity,
              child: root == null
                  ? const Center(
                      child: Text(
                        "Tree is empty",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    )
                  : CustomPaint(
                      painter: BSTPainter(root!, highlightedNodes, targetNode),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0A0A4F),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          DrawerHeader(
            child: Text(
              "Binary Search Tree",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "Traversal Algorithms:\n"
            "1. Inorder (LNR)\n"
            "2. Preorder (NLR)\n"
            "3. Postorder (LRN)\n",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ------------------ TREE PAINTER (same as before) ------------------
class BSTPainter extends CustomPainter {
  final BSTNode root;
  final List<BSTNode> highlighted;
  final BSTNode? targetNode;

  static const double nodeRadius = 10;
  static const double verticalGap = 30;
  static const int maxDepth = 4;
  bool reachedMaxDepth = false;

  BSTPainter(this.root, this.highlighted, this.targetNode);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    final paintNode = Paint()..color = Colors.white;

    void drawNode(BSTNode? node, double x, double y, double offsetX, int depth) {
      if (node == null) return;
      if (depth > maxDepth) {
        reachedMaxDepth = true;
        return;
      }

      if (node.left != null) {
        final childX = x - offsetX;
        final childY = y + verticalGap;
        if (depth < maxDepth) {
          canvas.drawLine(Offset(x, y), Offset(childX, childY), paintLine);
          drawNode(node.left, childX, childY, offsetX / 1.8, depth + 1);
        }
      }

      if (node.right != null) {
        final childX = x + offsetX;
        final childY = y + verticalGap;
        if (depth < maxDepth) {
          canvas.drawLine(Offset(x, y), Offset(childX, childY), paintLine);
          drawNode(node.right, childX, childY, offsetX / 1.8, depth + 1);
        }
      }

      Paint paint = paintNode;
      if (highlighted.contains(node)) paint = Paint()..color = Colors.red;
      if (targetNode == node) paint = Paint()..color = Colors.green;

      canvas.drawCircle(Offset(x, y), nodeRadius, paint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: node.value.toString(),
          style: const TextStyle(
            color: Color(0xFF0A0A4F),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    drawNode(root, size.width / 2, 60, size.width / 4, 1);

    if (reachedMaxDepth) {
      final warning = TextPainter(
        text: const TextSpan(
          text: "⚠️ Max Depth Reached (Level 4)",
          style: TextStyle(color: Colors.orange, fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      );
      warning.layout(maxWidth: size.width);
      warning.paint(
          canvas, Offset((size.width - warning.width) / 2, size.height - 40));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
