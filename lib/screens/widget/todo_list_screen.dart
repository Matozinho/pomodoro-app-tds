import 'package:flutter/material.dart';
import 'package:pomodoro/loading.dart';
import 'package:pomodoro/model/todo.dart';
import 'package:pomodoro/services/database_services.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  TextEditingController todoTitleControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade800,
          borderRadius: radius,
        ),
        child: StreamBuilder<List<Todo>>(
            stream: DatabaseService().listTodos(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Loading();
              }
              List<Todo>? todos = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const Text(
                      "Tarefas",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      width: 20,
                      height: 20,
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: todos?.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(todos![index].title),
                            background: Container(
                              padding: const EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              child: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                            onDismissed: (direction) async {
                              await DatabaseService()
                                  .removeTask(todos[index].uuid);
                            },
                            child: ListTile(
                              onTap: () {
                                DatabaseService().toggleTaskState(
                                  todos[index].uuid,
                                  todos[index].isCompleted,
                                );
                                DatabaseService().validateTaskConquest();
                              },
                              leading: Container(
                                padding: const EdgeInsets.all(2),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    width: 3.0,
                                    color: Colors.white,
                                  ),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: todos[index].isCompleted
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        textDirection: TextDirection.ltr,
                                      )
                                    : Container(),
                              ),
                              title: Text(
                                todos[index].title,
                                style: todos[index].isCompleted
                                    ? const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 20,
                                        color: Colors.white60,
                                      )
                                    : const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              title: Row(children: [
                const Text(
                  "Adicionar Tarefa",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    todoTitleControler.clear();
                  },
                )
              ]),
              children: [
                TextField(
                  controller: todoTitleControler,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.white,
                  ),
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Tarefa",
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.white60,
                    ),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () async {
                      if (todoTitleControler.text.isNotEmpty) {
                        await DatabaseService()
                            .createNewTodo(todoTitleControler.text.trim());
                        Navigator.pop(context);
                        todoTitleControler.clear();
                      }
                    },
                    child: const Text(
                      "Adicionar",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
