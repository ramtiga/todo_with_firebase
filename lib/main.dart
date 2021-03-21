import 'package:flutter/material.dart';
import 'package:todo_with_firebase/todo_form_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final tabs = [
      Container(),
      Container(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (value) => setState(() {
          selectedIndex = value;
        }),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.fact_check_outlined), label: 'Todos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_outline_outlined), label: 'Completed'),
        ],
      ),
      body: tabs[selectedIndex],
      floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () {
            showDialog(
                context: context,
                child: AddTodoDialogWidget(),
                barrierDismissible: false);
          },
          child: Icon(Icons.add)),
    );
  }
}

class AddTodoDialogWidget extends StatefulWidget {
  AddTodoDialogWidget({Key key}) : super(key: key);

  @override
  _AddTodoDialogWidgetState createState() => _AddTodoDialogWidgetState();
}

class _AddTodoDialogWidgetState extends State<AddTodoDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "Add Todo",
                  style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.cancel, color: Colors.grey, size: 30.0),
                    onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 8),
            TodoFormWidget(
              onChangedTitle: (title) => setState(() => this.title = title),
              onChangedDescription: (description) =>
                  setState(() => this.description = description),
              onSavedTodo: () {},
            ),
          ],
        ),
      );
}
