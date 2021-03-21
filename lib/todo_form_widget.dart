import 'package:flutter/material.dart';

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
            buildSave(),
          ],
        ),
      );
}

Widget buildTitle() => TextFormField(
      maxLines: 1,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Title',
      ),
    );

Widget buildSave() => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.indigo)),
          onPressed: () {},
          child: Text(
            'Save',
            style: TextStyle(color: Colors.white),
          )),
    );
