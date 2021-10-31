import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogsController extends ChangeNotifier {
  final _logs = <String>['asd', 'asdasd'];

  void addLog(String text) {
    _logs.add('[${DateTime.now()}] - $text');
    notifyListeners();
  }
}

class LogsView extends StatefulWidget {
  const LogsView({Key? key, required this.controller}) : super(key: key);

  final LogsController controller;

  @override
  _LogsViewState createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView> {
  void rebuild() => setState(() {});

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(5),
        itemCount: widget.controller._logs.length,
        itemBuilder: (context, index) {
          return Row(children: [
            const Text(
              '* ',
              style: TextStyle(fontFamily: 'Cascadia Code'),
            ),
            Text(
              widget.controller._logs[index],
              style: const TextStyle(fontFamily: 'Cascadia Code'),
            )
          ]);
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(rebuild);
    super.dispose();
  }
}
