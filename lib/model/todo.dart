import 'package:flutter/cupertino.dart';

class Todo {
  String title;
  String description;
  DateTime createdTime;
  String id;
  bool isDone;

  Todo({
    @required this.title,
    this.description = '',
    @required this.createdTime,
    this.id = '',
    this.isDone = false,
  });
}
