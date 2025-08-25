import 'package:flutter/material.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  final int _maxSize = 7; // Fixed size queue
  final TextEditingController _controller = TextEditingController();

  // For Linear Queue
  List<int?> _linearQueue = [];
  int _frontL = 0, _rearL = -1;
  String _messageL = "";

  // For Circular Queue
  List<int?> _circularQueue = [];
  int _frontC = -1, _rearC = -1;
  String _messageC = "";

  @override
  void initState() {
    super.initState();
    _linearQueue = List.filled(_maxSize, null);
    _circularQueue = List.filled(_maxSize, null);
  }

  // 🔹 RESET QUEUES
  void _refresh() {
    setState(() {
      _linearQueue = List.filled(_maxSize, null);
      _circularQueue = List.filled(_maxSize, null);
      _frontL = 0;
      _rearL = -1;
      _frontC = -1;
      _rearC = -1;
      _messageL = "";
      _messageC = "";
      _controller.clear();
    });
  }

  // 🔹 LINEAR QUEUE METHODS
  void _enqueueLinear() {
    final text = _controller.text;
    if (text.isEmpty) {
      setState(() => _messageL = "Enter a number to enqueue!");
      
      return;
    }
    final value = int.tryParse(text);
    if (value == null) {
      setState(() => _messageL = "Please enter a valid integer!");
      return;
    }
    if (text.length > 5) {
      setState(() {
        _messageL = "Number must be less than or equal to 5 digits!";
      });
      _controller.clear();
      return;
    }

    if (_rearL == _maxSize - 1) {
      setState(
        () => _messageL = "QUEUE OVERFLOW (Linear): Cannot insert more!",
      );
      _controller.clear();
      return;
    }

    setState(() {
      _rearL++;
      _linearQueue[_rearL] = value;
      _controller.clear();
      _messageL = "ENQUEUE: Inserted $value at REAR";
    });
  }

  void _dequeueLinear() {
    if (_frontL > _rearL) {
      setState(() => _messageL = "QUEUE UNDERFLOW (Linear): Queue is empty!");
      return;
    }

    final removed = _linearQueue[_frontL];
    setState(() {
      _linearQueue[_frontL] = null; // clear value
      _frontL++;
      _messageL = "DEQUEUE: Removed $removed from FRONT";
    });
  }

  void _peekLinear() {
    if (_frontL > _rearL) {
      setState(() => _messageL = "Queue is empty, nothing to peek!");
      return;
    }
    setState(() {
      _messageL = "PEEK: Front element is ${_linearQueue[_frontL]}";
    });
  }

  // 🔹 CIRCULAR QUEUE METHODS
  void _enqueueCircular() {
    final text = _controller.text;
    if (text.isEmpty) {
      setState(() => _messageC = "Enter a number to enqueue!");
      return;
    }
    final value = int.tryParse(text);
    if (value == null) {
      setState(() => _messageC = "Please enter a valid integer!");
      return;
    }
    if (text.length > 5) {
      setState(() {
        _messageL = "Number must be less than or equal to 5 digits!";
      });
      _controller.clear();
      return;
    }
    if ((_frontC == 0 && _rearC == _maxSize - 1) ||
        (_rearC + 1) % _maxSize == _frontC) {
      setState(() => _messageC = "QUEUE OVERFLOW (Circular)!");
      _controller.clear();
      return;
    }

    setState(() {
      if (_frontC == -1) {
        _frontC = _rearC = 0;
      } else {
        _rearC = (_rearC + 1) % _maxSize;
      }
      _circularQueue[_rearC] = value;
      _controller.clear();
      _messageC = "ENQUEUE: Inserted $value at REAR";
    });
  }

  void _dequeueCircular() {
    if (_frontC == -1) {
      setState(() => _messageC = "QUEUE UNDERFLOW (Circular)!");
      return;
    }

    final removed = _circularQueue[_frontC];
    setState(() {
      _circularQueue[_frontC] = null; // clear value
      if (_frontC == _rearC) {
        _frontC = _rearC = -1;
      } else {
        _frontC = (_frontC + 1) % _maxSize;
      }
      _messageC = "DEQUEUE: Removed $removed from FRONT";
    });
  }

  void _peekCircular() {
    if (_frontC == -1) {
      setState(() => _messageC = "Queue is empty!");
      return;
    }
    setState(() {
      _messageC = "PEEK: Front element is ${_circularQueue[_frontC]}";
    });
  }

  // 🔹 Visualization Helper Widget
  Widget _buildQueueVisualizer(
    List<int?> queue,
    int front,
    int rear, {
    required bool isCircular,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_maxSize, (i) {
        final isFront =
            i == front && (isCircular ? front != -1 : front <= rear);
        final isRear = i == rear && (isCircular ? rear != -1 : rear >= front);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Queue box
            Container(
              margin: const EdgeInsets.all(8),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: queue[i] != null ? Colors.amber.shade200 : Colors.white,
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  queue[i]?.toString() ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Pointer labels stacked vertically
            Column(
              children: [
                if (isFront)
                  const Text(
                    "↑ Front",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                if (isRear)
                  const Text(
                    "↑ Rear",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Linear + Circular
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        drawer: _buildDrawer(context),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A0A4F),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Exit the page
            },
          ),

          title: const Text(
            "Queue Visualizer",
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
          // 🔹 Add tabs here
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Linear Queue"),
              Tab(text: "Circular Queue"),
            ],
          ),
        ),

        body: TabBarView(
          children: [_buildLinearQueueUI(), _buildCircularQueueUI()],
        ),
      ),
    );
  }

  // Linear Queue UI
  Widget _buildLinearQueueUI() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _inputRow(),
                  const SizedBox(height: 1),
                  _actionRow(_enqueueLinear, _dequeueLinear, _peekLinear),
                  const SizedBox(height: 6),
                  Text(
                    _messageL,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQueueVisualizer(
                    _linearQueue,
                    _frontL,
                    _rearL,
                    isCircular: false,
                  ),
                  const SizedBox(height: 10),
                  _buildNote(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Circular Queue UI

  Widget _buildCircularQueueUI() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _inputRow(),
                  const SizedBox(height: 1),
                  _actionRow(_enqueueCircular, _dequeueCircular, _peekCircular),
                  const SizedBox(height: 6),
                  Text(
                    _messageC,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQueueVisualizer(
                    _circularQueue,
                    _frontC,
                    _rearC,
                    isCircular: true,
                  ),
                  const SizedBox(height: 10),
                  _buildNote(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Shared Input + Action Buttons
  Widget _inputRow() {
    return Row(
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
      ],
    );
  }

  Widget _actionRow(
    VoidCallback enqueue,
    VoidCallback dequeue,
    VoidCallback peek,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(onPressed: enqueue, child: const Text("ENQUEUE")),
        ElevatedButton(onPressed: dequeue, child: const Text("DEQUEUE")),
        ElevatedButton(onPressed: peek, child: const Text("PEEK/FRONT")),
      ],
    );
  }

  // 🔹 Drawer (like Stack)
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0A0A4F)),
            child: Text(
              "📘 Queue Information",
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
                  "ENQUEUE(x):\n"
                  "  if isFull(queue) → OVERFLOW\n"
                  "  else:\n"
                  "    rear ← rear + 1\n"
                  "    queue[rear] ← x\n\n"
                  "DEQUEUE():\n"
                  "  if isEmpty(queue) → UNDERFLOW\n"
                  "  else:\n"
                  "    return queue[front]\n"
                  "    front ← front + 1\n\n"
                  "PEEK():\n"
                  "  if isEmpty(queue) → return null\n"
                  "  else → return queue[front]",
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
                  "ENQUEUE → O(1)\n"
                  "DEQUEUE → O(1)\n"
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
              ListTile(title: Text("👉 Process Scheduling in OS")),
              ListTile(title: Text("👉 Printer Queue Management")),
              ListTile(title: Text("👉 Call Center Systems")),
              ListTile(title: Text("👉 BFS Graph Traversal")),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Note Section
  Widget _buildNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        " NOTE:\n"
        "1. Enqueue → Insert element at REAR.\n"
        "2. Dequeue → Remove element from FRONT.\n"
        "3. Peek/Fron → Shows the FRONT element.\n"
        "4. Linear Queue has limitation (unused spaces after dequeues).\n"
        "5. Circular Queue overcomes this by reusing empty spaces.\n",
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
