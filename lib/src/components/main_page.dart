import 'dart:io';
import 'dart:async';

import 'package:path/path.dart';
import 'package:watcher/watcher.dart';
import 'package:flutter/material.dart';
import 'package:monitor_project/src/utility.dart';
import 'package:monitor_project/src/base/config.dart';
import 'package:monitor_project/src/components/logs_view.dart';

import 'directory_selector.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  StreamSubscription? subscription;
  final logsController = LogsController();

  void rebuild() => setState(() {});

  @override
  void initState() {
    super.initState();
    AppConfig.instance.addListener(rebuild);
  }

  void handleDirectoryChange(WatchEvent event) async {
    if (event.type == ChangeType.ADD || event.type == ChangeType.MODIFY) {
      final ext = extension(event.path);

      if (ext == '.csv' || ext == '.txt') {
        createPDF(event.path, AppConfig.instance.outputDirectory.path);
      }
    }
  }

  void toggleListener() async {
    if (AppConfig.instance.isWatching) {
      AppConfig.instance.isWatching = false;
      logsController.addLog('Stopped Watching `Input Directory`');

      await subscription?.cancel();
      subscription = null;
    } else {
      AppConfig.instance.isWatching = true;
      logsController.addLog('Started Watching `Input Directory`');

      subscription = DirectoryWatcher(AppConfig.instance.inputDirectory.path)
          .events
          .listen(handleDirectoryChange);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            TextButton(
              onPressed: toggleListener,
              child: Text(
                config.isWatching ? 'Stop Watching' : 'Start Watching',
                style: const TextStyle(fontWeight: FontWeight.normal),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.blue,
                minimumSize: const Size(50, 45),
                padding: const EdgeInsets.symmetric(horizontal: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const Spacer(),
            if (config.isWatching) ...const [
              Text(
                'Listening to directory changes   ',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(strokeWidth: 1.5),
              ),
            ] else ...const [
              Text(
                'Not listening to changes',
                style: TextStyle(fontSize: 12),
              ),
            ]
          ]),
          Expanded(child: LogsView(controller: logsController)),
          // Divider(height: 30,),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  offset: Offset(0, 1),
                  color: Color.fromRGBO(0, 0, 0, .16),
                ),
              ],
            ),
            child: Column(children: [
              DirectorySelector(
                title: 'Input Directory',
                directory: config.inputDirectory.path,
                onChanged: (dir) => config.inputDirectory = Directory(dir),
              ),
              const Divider(height: 0),
              DirectorySelector(
                title: 'Output Directory',
                directory: config.outputDirectory.path,
                onChanged: (dir) => config.outputDirectory = Directory(dir),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    AppConfig.instance.removeListener(rebuild);
  }
}
