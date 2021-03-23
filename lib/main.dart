import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_with_firebase/provider/todos.dart';

final selectTabProvider = StateProvider<int>((ref) => 0);
final todoProvider = ChangeNotifierProvider((ref) => TodosProvider());

void main() {
  runApp(ProviderScope(child: MyApp()));
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

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final provider = watch(todoProvider);
    final todos = provider.todos;

    final tabs = [
      ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        separatorBuilder: (context, index) => Container(height: 8),
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              key: Key(todos[index].id),
              actions: [
                IconSlideAction(
                  color: Colors.green,
                  onTap: () {},
                  caption: 'Edit',
                  icon: Icons.edit,
                )
              ],
              secondaryActions: [
                IconSlideAction(
                  color: Colors.red,
                  onTap: () {},
                  caption: 'Delete',
                  icon: Icons.delete,
                )
              ],
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Checkbox(
                        activeColor: Theme.of(context).primaryColor,
                        checkColor: Colors.indigo,
                        value: todos[index].isDone,
                        onChanged: null),
                    SizedBox(width: 8),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todos[index].title,
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          todos[index].description,
                          style: TextStyle(fontSize: 18, height: 1.5),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      Container(),
    ];
    final selectedIndex = watch(selectTabProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex.state,
        onTap: (value) => selectedIndex.state = value,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.fact_check_outlined), label: 'Todos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_outline_outlined), label: 'Completed'),
        ],
      ),
      body: tabs[0],
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

class AddTodoDialogWidget extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();

  @override
  Widget build(BuildContext context,
          T Function<T>(ProviderBase<Object, T> provider) watch) =>
      AlertDialog(
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
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: title,
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Title',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a title';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: description,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.indigo)),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            //todos.addTodo(todo);
                            Navigator.of(context).pop();
                          },
                          child: Text('Save',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ),
              ),
            ),
            //onChangedTitle: (title) => this.title = title,
            //onChangedDescription: (description) =>
            //this.description = description,
            //  onSavedTodo: () {
            //final todo = Todo(
            //  title: title.text,
            //  description: description.text,
            //  createdTime: DateTime.now(),
            //  id: DateTime.now().toString(),
            //final todos = watch(todoProvider);
            //todos.addTodo(todo);
            //Navigator.of(context).pop();
          ],
        ),
      );
}
