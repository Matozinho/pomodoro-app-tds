import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/loading.dart';
import 'package:pomodoro/screens/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }
        return MaterialApp(
          title: 'Pomodoro App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.yellow,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const Home(),
        );
      },
    );
  }
}
