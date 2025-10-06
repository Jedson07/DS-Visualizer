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
    _collectTraversalNodes(root, type, traversal);

    message = "$type Traversal: ";
    setState(() {});

    for (var node in traversal) {
      highlightedNodes = [node];
      message = "$type Traversal: ${node.value}";
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 700));
    }

    highlightedNodes.clear();
    message =
        "$type Traversal Completed: ${traversal.map((n) => n.value).join(', ')}";
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

  void _collectTraversalNodes(
    BSTNode? node,
    String type,
    List<BSTNode> result,
  ) {
    if (node == null) return;

    if (type == "Preorder") {
      result.add(node);
      _collectTraversalNodes(node.left, type, result);
      _collectTraversalNodes(node.right, type, result);
    } else if (type == "Inorder") {
      _collectTraversalNodes(node.left, type, result);
      result.add(node);
      _collectTraversalNodes(node.right, type, result);
    } else if (type == "Postorder") {
      _collectTraversalNodes(node.left, type, result);
      _collectTraversalNodes(node.right, type, result);
      result.add(node);
    }
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

    void drawNode(
      BSTNode? node,
      double x,
      double y,
      double offsetX,
      int depth,
    ) {
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
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
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
        canvas,
        Offset((size.width - warning.width) / 2, size.height - 40),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
