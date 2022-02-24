import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_with_sql/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(Routes());
}
