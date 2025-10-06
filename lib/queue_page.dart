import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 🔹 for Clipboard

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

  // 🔹 Queue Source Codes (You can replace with your desired versions)
  final Map<String, String> _queueSourceCodes = {
    "Python": '''
class Queue:
    def __init__(self, size):
        self.queue = []
        self.size = size
    
    def enqueue(self, item):
        if len(self.queue) == self.size:
            print("Queue Overflow")
        else:
            self.queue.append(item)
    
    def dequeue(self):
        if not self.queue:
            print("Queue Underflow")
        else:
            return self.queue.pop(0)
    
    def peek(self):
        if not self.queue:
            print("Queue is empty")
        else:
            return self.queue[0]
''',
    "C": '''
#include <stdio.h>
#define SIZE 5

int queue[SIZE], front = -1, rear = -1;

void enqueue(int val) {
    if(rear == SIZE-1) printf("Queue Overflow\\n");
    else {
        if(front == -1) front = 0;
        queue[++rear] = val;
    }
}

void dequeue() {
    if(front == -1 || front > rear) printf("Queue Underflow\\n");
    else printf("Dequeued: %d\\n", queue[front++]);
}

void peek() {
    if(front == -1 || front > rear) printf("Queue Empty\\n");
    else printf("Front: %d\\n", queue[front]);
}
''',
    "C++": '''
#include <iostream>
using namespace std;
#define SIZE 5

class Queue {
    int arr[SIZE], front, rear;
public:
    Queue() { front = rear = -1; }
    void enqueue(int x) {
        if(rear == SIZE-1) cout << "Queue Overflow\\n";
        else {
            if(front == -1) front = 0;
            arr[++rear] = x;
        }
    }
    void dequeue() {
        if(front == -1 || front > rear) cout << "Queue Underflow\\n";
        else cout << "Dequeued: " << arr[front++] << endl;
    }
    void peek() {
        if(front == -1 || front > rear) cout << "Queue Empty\\n";
        else cout << "Front: " << arr[front] << endl;
    }
};
''',
    "Java": '''
class Queue {
    int size, front, rear, arr[];
    Queue(int n) {
        size = n;
        arr = new int[n];
        front = rear = -1;
    }
    void enqueue(int x) {
        if(rear == size-1) System.out.println("Queue Overflow");
        else {
            if(front == -1) front = 0;
            arr[++rear] = x;
        }
    }
    void dequeue() {
        if(front == -1 || front > rear) System.out.println("Queue Underflow");
        else System.out.println("Dequeued: " + arr[front++]);
    }
    void peek() {
        if(front == -1 || front > rear) System.out.println("Queue Empty");
        else System.out.println("Front: " + arr[front]);
    }
}
''',
  };

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
      _linearQueue[_frontL] = null;
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
        _messageC = "Number must be less than or equal to 5 digits!";
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
      _circularQueue[_frontC] = null;
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

  // 🔹 Visualization Helper
  Widget _buildQueueVisualizer(
    List<int?> queue,
    int front,
    int rear, {
    required bool isCircular,
  }) {
    const double boxSize = 40; // reduced size
    const double boxMargin = 1;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Front pointers row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_maxSize, (i) {
              bool showFront = (i == front);
              return SizedBox(
                width: boxSize + boxMargin * 2,
                child: Column(
                  children: [
                    showFront
                        ? const Text(
                            "Front",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          )
                        : const SizedBox(height: 14),
                    showFront
                        ? const Text(
                            "↓",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox(height: 14),
                  ],
                ),
              );
            }),
          ),
        ),

        // Queue boxes row (scrollable)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_maxSize, (i) {
              return Container(
                margin: const EdgeInsets.all(boxMargin),
                width: boxSize,
                height: boxSize,
                decoration: BoxDecoration(
                  color: queue[i] != null
                      ? Colors.amber.shade200
                      : Colors.white,
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    queue[i]?.toString() ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          ),
        ),

        // Rear pointers row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_maxSize, (i) {
              bool showRear = (i == rear);
              return SizedBox(
                width: boxSize + boxMargin * 2,
                child: Column(
                  children: [
                    showRear
                        ? const Text(
                            "↑",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox(height: 14),
                    showRear
                        ? const Text(
                            "Rear",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          )
                        : const SizedBox(height: 14),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // 🔹 Source Code Dialog
  void _showSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String selectedLang = "Python";
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Queue Source Code"),
              content: SizedBox(
                width: 600,
                height: 420,
                child: Column(
                  children: [
                    Wrap(
                      spacing: 8,
                      children: _queueSourceCodes.keys.map((lang) {
                        return ChoiceChip(
                          label: Text(lang),
                          selected: selectedLang == lang,
                          onSelected: (val) {
                            if (val) setStateDialog(() => selectedLang = lang);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SelectableText(
                            _queueSourceCodes[selectedLang]!,
                            style: const TextStyle(
                              fontFamily: "monospace",
                              fontSize: 14,
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
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: _queueSourceCodes[selectedLang]!),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("$selectedLang code copied!")),
                    );
                  },
                  child: const Text("COPY"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("CLOSE"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        drawer: _buildDrawer(context),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A0A4F),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Queue Visualizer",
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

  Widget _buildLinearQueueUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _inputRow(),
          const SizedBox(height: 1),
          _actionRow(_enqueueLinear, _dequeueLinear, _peekLinear),
          const SizedBox(height: 6),
          Text(
            _messageL,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
    );
  }

  Widget _buildCircularQueueUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _inputRow(),
          const SizedBox(height: 1),
          _actionRow(_enqueueCircular, _dequeueCircular, _peekCircular),
          const SizedBox(height: 6),
          Text(
            _messageC,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
    );
  }

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
          ExpansionTile(
            leading: const Icon(Icons.code_off),
            title: const Text("Source Code"),
            children: [
              ListTile(
                title: const Text("View Queue Source Codes"),
                onTap: _showSourceDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }

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
        "3. Linear Queue → Wastes space after deletions.\n"
        "4. Circular Queue → Efficient, reuses freed space.\n",
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
