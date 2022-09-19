import 'package:flutter/cupertino.dart';
import 'package:lab1/main.dart';


class Todos with ChangeNotifier{
  List<Todo> _todos = <Todo>[];

  List<Todo> get todos => _todos;

  addTodo(Todo todo){
    _todos.add(todo);
    
    notifyListeners();



  }

}