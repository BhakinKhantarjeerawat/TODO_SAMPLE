/// This main.dart use State management system called 'MultiProvider'.
/// Together with the help of ChangeNotifier(a statemanagement system),
/// it helps sending and recieving data between classes(screen, database, etc.) run effectively.

import 'package:flutter/material.dart';
import 'package:to_do_hugeman/providers/taskDetailProvider.dart';
import 'package:provider/provider.dart';
import 'package:to_do_hugeman/screens/homeScreen.dart';
import 'database/databaseHelper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TodoApp());
}

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  @override
  Widget build(BuildContext context) {
    /// use MultiProvider to works with more than providers in an app
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DatabaseHelper.instance),
          ChangeNotifierProvider(create: (_) => TaskDetailProvider()),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        ));
  }
}
