import 'package:flutter/material.dart';
import 'package:pomodoro/screens/widget/home_drawer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:pomodoro/screens/widget/home_screen.dart';
import 'package:pomodoro/screens/widget/todo_list_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _globalDrawerKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return Scaffold(
      key: _globalDrawerKey, //needed for sandwich icon open drawer
      drawer: const HomeDrawer(),
      body: SlidingUpPanel(
        panel: const TodoListScreen(),
        collapsed: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: radius,
          ),
          child: const Center(
            child: Text(
              "Lista de Tarefas",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        body: Center(
          child: HomeScreen(globalDrawerKey: _globalDrawerKey),
        ),
        borderRadius: radius,
      ),
    );
  }
}
