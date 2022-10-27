import 'package:flutter/cupertino.dart';
import 'package:lab1/main.dart';

class TodosProvider with ChangeNotifier {
  List<Todo> _todos = <Todo>[
    // Todo("This data is provided from provider", false),
    // Todo("addMySec", true)
  ];

  List<Todo> get todos => _todos;

  refreshTodos(Future<List<Todo>> todoList) async {
    _todos = await todoList;

    notifyListeners();
  }
}
