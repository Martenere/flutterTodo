import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'serverHandle.dart';
import 'package:provider/provider.dart';
import 'add_item_page.dart';

class Todo {
  String id = "";
  String name;
  bool isDone;

  Todo(this.name, this.isDone, [this.id = ""]);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Welcome to Flutter',
      home: toDoList(),
    );
  }
}

class toDoList extends StatefulWidget {
  const toDoList({super.key});

  @override
  State<toDoList> createState() => _toDoListState();
}

class _toDoListState extends State<toDoList> {
  final _biggerFont = const TextStyle(fontSize: 33.0);

  final _biggerFontComplete = const TextStyle(
      fontSize: 33.0,
      color: Colors.green,
      decoration: TextDecoration.lineThrough);

  List<Todo> todos = <Todo>[Todo("addMyFirst", false), Todo("addMySec", true)];
  bool? _filter;
  late Future<String> id;
  late final server;

  void removeItem(Todo todo) {
    setState(() {
      todos.remove(todo);
    });
  }

  void addItem(String name) {
    setState(() {
      todos.add(Todo(name, false));
    });
  }

  void pushToServer(String name) {
    server.createTodo(name);
  }

  void _checkTodo(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void filterPage(int selFilter) {
    setState(() {
      if (selFilter == 0) {
        _filter = null;
      }
      if (selFilter == 1) {
        _filter = true;
      }
      if (selFilter == 2) {
        _filter = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      server = serverTodo();
      server.createKey();
      todos = server.returnTodos();
    });
  }

  void _goToAddItemPage() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: const Text('add item')),
          body: AddItemCol(addActivity: pushToServer));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                setState(() {
                  filterPage(value);
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 0, child: Text("All")),
                const PopupMenuItem(value: 1, child: Text("Completed")),
                const PopupMenuItem(value: 2, child: Text("Incompleted"))
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _goToAddItemPage,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: todos
              .where(
            (todo) => ((_filter == null) ? true : todo.isDone == _filter),
          )
              .map((Todo todo) {
            return TodoItemListTile(
                todo: todo,
                onTodoChanged: _checkTodo,
                onTodoRemove: removeItem);
          }).toList(),
        ));
  }
}

class TodoItemListTile extends StatelessWidget {
  const TodoItemListTile(
      {super.key,
      required this.todo,
      required this.onTodoChanged,
      required this.onTodoRemove});
  final Todo todo;
  final Function onTodoChanged;
  final Function onTodoRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: todo.isDone
          ? const Icon(Icons.check_box)
          : const Icon(Icons.check_box_outline_blank),
      title: Text(todo.name),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          onTodoRemove(todo);
        },
      ),
      onTap: () {
        onTodoChanged(todo);
      },
    );
  }
}
