import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_with_firebase/provider/todos.dart';

final todoProvider = ChangeNotifierProvider((ref) => TodosProvider());

class TodoFormWidget extends StatelessWidget {
  final String title;
  final String description;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final VoidCallback onSavedTodo;

  const TodoFormWidget({
    Key key,
    this.title = '',
    this.description = '',
    @required this.onChangedTitle,
    @required this.onChangedDescription,
    @required this.onSavedTodo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTitle(),
            buildDescription(),
            buildSaveButton(),
          ],
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Title',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'タイトルを入力してください';
          } else {
            return null;
          }
        },
      );

  Widget buildDescription() => TextFormField(
        maxLines: 3,
        initialValue: description,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Description',
        ),
      );

  Widget buildSaveButton() => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.indigo)),
            onPressed: onSavedTodo,
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            )),
      );
}
