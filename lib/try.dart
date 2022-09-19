import 'package:http/http.dart';
import 'dart:convert';
import 'main.dart';

main() {
  print("hej");
  ServerHandler server = ServerHandler();
  server.getKey();
  print(server.key);
}

class ServerHandler {
  List<Todo> todos = <Todo>[];
  String key = "asdf";

  Future<void> getKey() async {
    var url = await Uri.https('todoapp-api.apps.k8s.gu.se', 'register');
    Response response = await get(url);
    key = response.body;
    print(key);
  }
}
