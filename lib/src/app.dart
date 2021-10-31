import 'package:flutter/material.dart';
import 'package:monitor_project/src/base/config.dart';
import 'package:monitor_project/src/components/main_page.dart';

class App extends StatelessWidget {
  static Future<void> initializeAndRun() async {
    await AppConfig.initialize();

    return runApp(const App._());
  }

  const App._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainPage(),
      theme: ThemeData(fontFamily: 'Roboto'),
    );
  }
}
