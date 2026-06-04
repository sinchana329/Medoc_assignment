import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Map<String, dynamic>> tasks = [
    {"title": "Make Tutorial", "done": false},
    {"title": "Do Exercise", "done": true},
    {"title": "Study Flutter", "done": true},
    {"title": "Code App", "done": false},
  ];

  void addTask() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Task"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter task",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  tasks.add({
                    "title": controller.text,
                    "done": false,
                  });
                });
                Navigator.pop(context);
              },
              child: Text("Add"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Center(
          child: Text("TO DO"),
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: CheckboxListTile(
              title: Text(tasks[index]["title"]),
              value: tasks[index]["done"],
              onChanged: (value) {
                setState(() {
                  tasks[index]["done"] = value;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: addTask,
        child: Icon(Icons.add),
      ),
    );
  }
}