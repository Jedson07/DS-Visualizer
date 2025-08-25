import 'package:flutter/material.dart';
import 'dart:math';

class LinkedListPage extends StatefulWidget {
  const LinkedListPage({super.key});

  @override
  State<LinkedListPage> createState() => _LinkedListPageState();
}

class Node {
  int value;
  String address;
  String nextAddress;
  Node? next;
  Node(this.value) : address = _randomAddress(), nextAddress = 'NIL';

  static String _randomAddress() {
    final rand = Random();
    return '0x${List.generate(4, (_) => rand.nextInt(16).toRadixString(16)).join()}';
  }
}

class _LinkedListPageState extends State<LinkedListPage> {
  Node? head;
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _posController = TextEditingController();
  String _message = "";

  // Insert at beginning
  void _insertAtBeginning() {
    if (!_validateValue()) return;
    final val = int.parse(_valueController.text);
    if (_countNodes() >= 10) {
      _showLimitSnackBar();
      return;
    }
    final newNode = Node(val);
    newNode.next = head;
    newNode.nextAddress = head?.address ?? 'NIL';
    setState(() {
      head = newNode;
      _clearInputs();
      _message = "Inserted $val at the BEGINNING";
      _updateAddresses();
    });
  }

  // Insert at end
  void _insertAtEnd() {
    if (!_validateValue()) return;
    final val = int.parse(_valueController.text);
    if (_countNodes() >= 10) {
      _showLimitSnackBar();
      return;
    }
    final newNode = Node(val);
    if (head == null) {
      setState(() {
        head = newNode;
        _clearInputs();
        _message = "Inserted $val at the END (List was empty)";
      });
      return;
    }
    Node temp = head!;
    while (temp.next != null) {
      temp = temp.next!;
    }
    temp.next = newNode;
    temp.nextAddress = newNode.address;
    setState(() {
      _clearInputs();
      _message = "Inserted $val at the END";
      _updateAddresses();
    });
  }

  // Insert at position
  void _insertAtPosition() {
    if (!_validateValue()) return;
    if (_posController.text.isEmpty) {
      setState(() => _message = "Enter position!");
      return;
    }
    final val = int.parse(_valueController.text);
    final pos = int.tryParse(_posController.text);
    if (pos == null || pos < 1) {
      setState(() => _message = "Invalid position!");
      return;
    }
    if (_countNodes() >= 10) {
      _showLimitSnackBar();
      return;
    }

    final newNode = Node(val);

    if (pos == 1 || head == null) {
      newNode.next = head;
      newNode.nextAddress = head?.address ?? 'NIL';
      setState(() {
        head = newNode;
        _clearInputs();
        _message = "Inserted $val at position $pos";
        _updateAddresses();
      });
      return;
    }

    Node temp = head!;
    int index = 1;
    while (temp.next != null && index < pos - 1) {
      temp = temp.next!;
      index++;
    }

    newNode.next = temp.next;
    newNode.nextAddress = temp.next?.address ?? 'NIL';
    temp.next = newNode;
    temp.nextAddress = newNode.address;

    setState(() {
      _clearInputs();
      _message = "Inserted $val at position $pos";
      _updateAddresses();
    });
  }

  // Delete at beginning
  void _deleteAtBeginning() {
    if (head == null) {
      setState(() => _message = "List is empty!");
      return;
    }
    final removed = head!.value;
    setState(() {
      head = head!.next;
      _message = "Deleted $removed from BEGINNING";
      _updateAddresses();
    });
  }

  // Delete at end
  void _deleteAtEnd() {
    if (head == null) {
      setState(() => _message = "List is empty!");
      return;
    }
    if (head!.next == null) {
      final removed = head!.value;
      setState(() {
        head = null;
        _message = "Deleted $removed from END (List empty now)";
      });
      return;
    }
    Node temp = head!;
    while (temp.next?.next != null) {
      temp = temp.next!;
    }
    final removed = temp.next!.value;
    temp.next = null;
    temp.nextAddress = 'NIL';
    setState(() {
      _message = "Deleted $removed from END";
      _updateAddresses();
    });
  }

  // Delete at position
  void _deleteAtPosition() {
    if (head == null) {
      setState(() => _message = "List is empty!");
      return;
    }
    if (_posController.text.isEmpty) {
      setState(() => _message = "Enter position!");
      return;
    }
    final pos = int.tryParse(_posController.text);
    if (pos == null || pos < 1) {
      setState(() => _message = "Invalid position!");
      return;
    }

    if (pos == 1) {
      final removed = head!.value;
      setState(() {
        head = head!.next;
        _clearInputs();
        _message = "Deleted $removed from position $pos";
        _updateAddresses();
      });
      return;
    }

    Node temp = head!;
    int index = 1;
    while (temp.next != null && index < pos - 1) {
      temp = temp.next!;
      index++;
    }

    if (temp.next == null) {
      setState(() {
        _clearInputs();
        _message = "Position out of range!";
      });
      return;
    }

    final removed = temp.next!.value;
    temp.next = temp.next!.next;
    temp.nextAddress = temp.next?.address ?? 'NIL';

    setState(() {
      _clearInputs();
      _message = "Deleted $removed from position $pos";
      _updateAddresses();
    });
  }

  // Traverse
  void _traverse() {
    if (head == null) {
      setState(() => _message = "List is empty!");
      return;
    }
    List<int> values = [];
    Node? temp = head;
    while (temp != null) {
      values.add(temp.value);
      temp = temp.next;
    }
    setState(() {
      _message = "Traversal: ${values.join(' → ')}";
    });
  }

  // Utility methods
  bool _validateValue() {
    if (_valueController.text.isEmpty) {
      setState(() => _message = "Enter a number!");
      return false;
    }
    final value = int.tryParse(_valueController.text);
    if (value == null) {
      setState(() => _message = "Invalid integer!");
      return false;
    }
    return true;
  }

  void _showLimitSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Maximum 10 elements allowed in the linked list!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  int _countNodes() {
    int count = 0;
    Node? temp = head;
    while (temp != null) {
      count++;
      temp = temp.next;
    }
    return count;
  }

  void _updateAddresses() {
    Node? temp = head;
    while (temp != null) {
      temp.nextAddress = temp.next?.address ?? 'NIL';
      temp = temp.next;
    }
  }

  void _clearInputs() {
    _valueController.clear();
    _posController.clear();
  }

  void _refresh() {
    setState(() {
      head = null;
      _clearInputs();
      _message = "";
    });
  }

  // Node visual
  Widget _buildNode(Node node) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black87, width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black87, width: 1.5),
                      ),
                    ),
                    child: Text(
                      node.value.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    width: 55,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      node.nextAddress,
                      style: const TextStyle(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),
            Text(node.address, style: const TextStyle(fontSize: 11)),
          ],
        ),
        if (node.next != null)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(Icons.arrow_forward, size: 24, color: Colors.black),
          ),
      ],
    );
  }

  Widget _buildNote() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "NOTE:\n"
        "1. Insert at Beginning, End or at given Position.\n"
        "2. Delete at Beginning, End or given Position.\n"
        "3. Traverse displays elements in order.\n"
        "4. Each node stores: Value + Address + Next Node Address.\n"
        "5. Head points to first node, NIL means end of list.",
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
          "Linked List Visualizer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refresh,
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
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
                "📘 Linked List Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ExpansionTile(
              leading: const Icon(Icons.code),
              title: const Text("Pseudo Code"),
              children: const [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "INSERT_BEGIN(x):\n"
                    "  newNode ← create(x)\n"
                    "  newNode.next = head\n"
                    "  head = newNode\n\n"
                    "INSERT_END(x):\n"
                    "  newNode ← create(x)\n"
                    "  if head=NIL → head=newNode\n"
                    "  else traverse to last → last.next=newNode\n\n"
                    "INSERT_POS(x,p):\n"
                    "  newNode ← create(x)\n"
                    "  if p==1 → newNode.next=head → head=newNode\n"
                    "  else traverse to p-1 → insert after it\n\n"
                    "DELETE_BEGIN():\n"
                    "  if head≠NIL → head=head.next\n\n"
                    "DELETE_END():\n"
                    "  if head=NIL → return\n"
                    "  if head.next=NIL → head=NIL\n"
                    "  else traverse to last-1 → last.next=NIL\n\n"
                    "DELETE_POS(p):\n"
                    "  if p==1 → head=head.next\n"
                    "  else traverse to p-1 → bypass node\n\n"
                    "TRAVERSE():\n"
                    "  temp=head\n"
                    "  while temp≠NIL → print(temp.val); temp=temp.next\n\n"
                    "COUNT():\n"
                    "  c=0; temp=head\n"
                    "  while temp≠NIL → c++ ; temp=temp.next\n"
                    "  print(c)\n\n"
                    "REVERSE():\n"
                    "  prev=NIL; curr=head\n"
                    "  while curr≠NIL → next=curr.next; curr.next=prev;\n"
                    "    prev=curr; curr=next; head=prev",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.timer),
              title: const Text("Time Complexity"),
              children: const [
                ListTile(
                  title: Text(
                    "Insert at Begin → O(1)\n"
                    "Insert at End → O(n)\n"
                    "Insert at Position → O(n)\n"
                    "Delete at Begin → O(1)\n"
                    "Delete at End → O(n)\n"
                    "Delete at Position → O(n)\n"
                    "Traverse → O(n)",
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.apps),
              title: const Text("Applications"),
              children: const [
                ListTile(title: Text("👉 Dynamic Memory Allocation")),
                ListTile(title: Text("👉 Implementation of Stacks & Queues")),
                ListTile(title: Text("👉 Undo/Redo operations")),
                ListTile(title: Text("👉 Polynomial operations")),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _valueController,
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
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    controller: _posController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter position",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 4,
              runSpacing: 4,
              children: [
                ElevatedButton(
                  onPressed: _insertAtBeginning,
                  child: const Text("Insert Begin"),
                ),
                ElevatedButton(
                  onPressed: _insertAtPosition,
                  child: const Text("Insert Pos"),
                ),
                ElevatedButton(
                  onPressed: _insertAtEnd,
                  child: const Text("Insert End"),
                ),
                ElevatedButton(
                  onPressed: _deleteAtBeginning,
                  child: const Text("Delete Begin"),
                ),
                ElevatedButton(
                  onPressed: _deleteAtPosition,
                  child: const Text("Delete Pos"),
                ),
                ElevatedButton(
                  onPressed: _deleteAtEnd,
                  child: const Text("Delete End"),
                ),
                ElevatedButton(
                  onPressed: _traverse,
                  child: const Text("Traverse"),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _message,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: _buildLinkedListVisual()),
              ),
            ),
            const SizedBox(height: 50),
            _buildNote(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLinkedListVisual() {
    List<Widget> widgets = [];
    Node? temp = head;
    while (temp != null) {
      widgets.add(_buildNode(temp));
      temp = temp.next;
    }
    return widgets;
  }
}