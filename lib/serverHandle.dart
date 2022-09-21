import 'package:http/http.dart';
import 'dart:convert';
import 'main.dart';

void main() {
  print("hey");
}

class serverTodo {
  List<Todo> todos = <Todo>[Todo("1234", false)];
  String key = "";

  serverTodo();

  List<Todo> returnTodos() {
    return todos;
  }

  Future<void> createNewKey() async {
    var url = Uri.https('todoapp-api.apps.k8s.gu.se', 'register');
    Response response = await get(url);
    key = response.body;
    print(key);
  }

  void convertJsonToList(String jsonString) {
    List newTodos = jsonDecode(jsonString);
    List<Todo> newTodosDecoded = <Todo>[];
    print(newTodos);

    for (var todoNew in newTodos) {
      newTodosDecoded.add(Todo(
        todoNew['title'],
        todoNew['done'],
        todoNew["id"],
      ));

      ;
    }
  }

  void uploadTodo(String title) async {
    var url = Uri.https('todoapp-api.apps.k8s.gu.se', 'todos', {'key': key});
    Map<String, dynamic> bodyPayload = {"title": title, "done": false};

    Response response = await post(
      url,
      body: jsonEncode(bodyPayload),
      headers: {"Content-Type": "application/json"},
    );
    var jsonBody = response.body;
    convertJsonToList(jsonBody);
  }

  void retrieveTodos() async {
    var url = Uri.https('todoapp-api.apps.k8s.gu.se', 'todos', {'key': key});
    Response response = await get(url);
    convertJsonToList(response.body);
  }

  void updateTodo(Todo todo, bool newCheckValue, [String newName = ""]) async {
    String id = todo.id;
    String title = (newName != "") ? newName : todo.name;

    Map<String, dynamic> bodyPayload = {"title": title, "done": newCheckValue};

    var url =
        Uri.https('todoapp-api.apps.k8s.gu.se', 'todos:$id', {'key': key});

    Response response = await put(
      url,
      body: jsonEncode(bodyPayload),
      headers: {"Content-Type": "application/json"},
    );
  }

  void removeTodo(String id) {
    var url =
        Uri.https('todoapp-api.apps.k8s.gu.se', 'todos:$id', {'key': key});
    delete(url);
  }

  //return response.body;

}
