import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_with_firebase/main.dart';

import 'model/todo.dart';

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
                            final provider = watch(todoProvider);
                            final todo = Todo(
                              title: title.text,
                              description: description.text,
                              createdTime: DateTime.now(),
                              id: DateTime.now().toString(),
                            );
                            provider.addTodo(todo);
                            Navigator.of(context).pop();
                          },
                          child: Text('Save',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
