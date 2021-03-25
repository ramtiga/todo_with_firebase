import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_with_firebase/model/todo.dart';

import 'main.dart';

class EditTodoPage extends StatelessWidget {
  const EditTodoPage({Key key, @required this.todo}) : super(key: key);
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String title = todo.title;
    String description = todo.description;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Todo'),
        actions: [
          Consumer(
            builder: (context, watch, child) => IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                final provider = watch(todoProvider);
                provider.removeTodo(todo);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Consumer(
              builder: (context, watch, child) => Column(
                children: [
                  TextFormField(
                    initialValue: title,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Title',
                    ),
                    onChanged: (value) => title = value,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a title';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    initialValue: description,
                    maxLines: 5,
                    onChanged: (value) => description = value,
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
                    child: Consumer(
                      builder: (context, watch, child) => ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.indigo)),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            final provider = watch(todoProvider);
                            provider.updateTodo(todo, title, description);
                            Navigator.of(context).pop();
                          },
                          child: Text('Save',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
