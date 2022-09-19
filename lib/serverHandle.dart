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

  Future<void> createKey() async {
    var url = Uri.https('todoapp-api.apps.k8s.gu.se', 'register');
    Response response = await get(url);
    key = response.body;
    print(key);
  }

  void convertJsonToList(String jsonString) {
    List<String> ids = [];
    List newTodos = jsonDecode(jsonString);
    for (var todo in todos) {
      ids.add(todo.id);
    }

    for (var todoNew in newTodos) {
      if (!ids.contains(todoNew["id"])) {
        todos.add(Todo(
          todoNew['title'],
          todoNew['done'],
          todoNew["id"],
        ));

        ;
      }
    }
  }

  void createTodo(String title) async {
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
    var url = Uri.parse('https://todoapp-api.apps.k8s.gu.se/register');
    Response response = await get(url);
  }

  //return response.body;

}
