import 'dart:ffi';

import 'package:http/http.dart';
import 'dart:convert';
import 'main.dart';

void main() {
  print("hey");
}

class serverTodo {
  String key = "";

  serverTodo();

  void createNewKey() async {
    var url = Uri.https('todoapp-api.apps.k8s.gu.se', 'register');
    Response response = await get(url);
    key = response.body;
    print(key);
  }

  List<Todo> convertJsonToTodoList(String jsonString) {
    List jsonList = jsonDecode(jsonString);
    List<Todo> todosDecoded = <Todo>[];
    print("func convert jsontotodolist: Decoded $jsonList");

    for (var todo in jsonList) {
      todosDecoded.add(Todo(
        todo['title'],
        todo['done'],
        todo["id"],
      ));

      ;
    }
    return todosDecoded;
  }

  Future<List<Todo>> uploadTodo(String title) async {
    var url = Uri.https('todoapp-api.apps.k8s.gu.se', 'todos', {'key': key});
    Map<String, dynamic> bodyPayload = {"title": title, "done": false};

    Response response = await post(
      url,
      body: jsonEncode(bodyPayload),
      headers: {"Content-Type": "application/json"},
    );
    var jsonBody = response.body;
    var decodedTodos = convertJsonToTodoList(jsonBody);
    return decodedTodos;
  }

  Future<List<Todo>> retrieveTodos() async {
    var url = Uri.https('todoapp-api.apps.k8s.gu.se', 'todos', {'key': key});
    Response response = await get(url);
    return convertJsonToTodoList(response.body);
  }

  Future<List<Todo>>  updateTodo(Todo todo, bool newCheckValue, [String newName = ""]) async {
    String id = todo.id;
    String title = (newName != "") ? newName : todo.name;

    Map<String, dynamic> bodyPayload = {"title": title, "done": newCheckValue};

    var url =
        Uri.https('todoapp-api.apps.k8s.gu.se', 'todos/$id', {'key': key});

    Response response = await put(
      url,
      body: jsonEncode(bodyPayload),
      headers: {"Content-Type": "application/json"},
    );
    print("func updateTodo: updated: ${response.body}");
    return convertJsonToTodoList(response.body);
  }

  Future<List<Todo>> removeTodo(String id) async {
    var url =
        Uri.https('todoapp-api.apps.k8s.gu.se', 'todos/$id', {'key': key});
    Response response = await delete(url);
    print("func removeTodo: deleted: ${response.body}");
    return convertJsonToTodoList(response.body);

    //return convertJsonToTodoList(response.body);
  }

  //return response.body;

}
