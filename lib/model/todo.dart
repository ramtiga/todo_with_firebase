import 'package:flutter/cupertino.dart';

import '../utils.dart';

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

  static Todo fromJson(Map<String, dynamic> json) => Todo(
        createdTime: Utils.toDateTime(json['createdTime']),
        title: json['title'],
        description: json['description'],
        id: json['id'],
        isDone: json['isDone'],
      );

  Map<String, dynamic> toJson() => {
        'createdTime': Utils.fromDateTimeToJson(createdTime),
        'title': title,
        'description': description,
        'id': id,
        'isDone': isDone,
      };
}
