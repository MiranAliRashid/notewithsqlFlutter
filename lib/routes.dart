import 'package:flutter/material.dart';
import 'package:note_with_sql/Screens/show_notes.dart';

class Routes extends StatefulWidget {
  Routes({Key? key}) : super(key: key);

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: "/", routes: {
      "/": (context) => ShowNotes(),
    });
  }
}
