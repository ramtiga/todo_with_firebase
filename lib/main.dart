import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_with_firebase/add_todo.dart';
import 'package:todo_with_firebase/api/firebase_api.dart';
import 'package:todo_with_firebase/provider/todos.dart';
import 'package:todo_with_firebase/todo_edit_widget.dart';
import 'package:todo_with_firebase/utils.dart';

import 'model/todo.dart';

final selectTabProvider = StateProvider<int>((ref) => 0);
final todoProvider = ChangeNotifierProvider((ref) => TodosProvider());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabs = [
      buildTodoListWidget(),
      buildTodoCompleteListWidget(),
    ];

    return Consumer(builder: (context, watch, child) {
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
          onTap: (value) {
            selectedIndex.state = value;
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.fact_check_outlined), label: 'Todos'),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_outline_outlined), label: 'Completed'),
          ],
        ),
        body: StreamBuilder<List<Todo>>(
            stream: FirebaseApi.readTodos(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error...'),
                    );
                  } else {
                    final todos = snapshot.data;
                    context.read(todoProvider).setTodos(todos);
                    return tabs[selectedIndex.state];
                  }
              }
            }),
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
    });
  }

  Widget buildTodoListWidget() {
    return Consumer(builder: (context, watch, child) {
      final provider = watch(todoProvider);
      final todos = provider.todos;

      return ListView.separated(
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
                  onTap: () => editTodo(context, todos[index]),
                  caption: 'Edit',
                  icon: Icons.edit,
                )
              ],
              secondaryActions: [
                IconSlideAction(
                  color: Colors.red,
                  onTap: () => deleteTodo(context, todos[index], provider),
                  caption: 'Delete',
                  icon: Icons.delete,
                )
              ],
              child: GestureDetector(
                onTap: () => editTodo(context, todos[index]),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Checkbox(
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Colors.indigo,
                          value: todos[index].isDone,
                          onChanged: (_) {
                            bool isDone =
                                provider.toggleTodoStatus(todos[index]);
                            Utils.showSnackBar(context,
                                isDone ? 'todo completed' : 'todo imcompleted');
                          }),
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
            ),
          );
        },
      );
    });
  }

  Widget buildTodoCompleteListWidget() {
    return Consumer(builder: (context, watch, child) {
      final provider = watch(todoProvider);
      final todos = provider.todosCompleted;

      return ListView.separated(
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
                  onTap: () {
                    editTodo(context, todos[index]);
                  },
                  caption: 'Edit',
                  icon: Icons.edit,
                )
              ],
              secondaryActions: [
                IconSlideAction(
                  color: Colors.red,
                  onTap: () => deleteTodo(context, todos[index], provider),
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
                        checkColor: Colors.white,
                        value: todos[index].isDone,
                        onChanged: (_) {
                          bool isDone = provider.toggleTodoStatus(todos[index]);
                          Utils.showSnackBar(context,
                              isDone ? 'todo completed' : 'todo imcompleted');
                        }),
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
      );
    });
  }

  void deleteTodo(BuildContext context, Todo todo, provider) {
    provider.removeTodo(todo);
    Utils.showSnackBar(context, 'Delete the todo');
  }

  void editTodo(BuildContext context, Todo todo) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EditTodoPage(todo: todo)));
  }
}
