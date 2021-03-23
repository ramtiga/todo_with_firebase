import 'package:flutter/material.dart';
import 'package:todo_with_firebase/model/todo.dart';

class TodosProvider extends ChangeNotifier {
  List<Todo> _todos = [
    Todo(
        title: 'TOEIC勉強',
        description: '''英単語100
      英熟語復習''',
        createdTime: DateTime.now()),
    Todo(
        title: '買い物',
        description: '''バナナ
      牛乳
      パン
      たまご''',
        createdTime: DateTime.now()),
  ];

  List<Todo> get todos => _todos.where((todo) => todo.isDone == false).toList();
  List<Todo> get todosCompleted =>
      _todos.where((todo) => todo.isDone == true).toList();

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }
}
