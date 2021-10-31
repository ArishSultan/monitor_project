import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogsController extends ChangeNotifier {
  final _logs = <String>[];

  void addLog(String text) {
    final date = DateTime.now();

    final day = _fixZeros(date.day);
    final hour = _fixZeros(date.hour);
    final year = _fixZeros(date.year);
    final month = _fixZeros(date.month);
    final minute = _fixZeros(date.minute);
    final second = _fixZeros(date.second);

    _logs.add('[$year-$month-$day $hour:$minute:$second] - $text');
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
            Expanded(
              child: Text(
                widget.controller._logs[index],
                style: const TextStyle(fontFamily: 'Cascadia Code', fontSize: 10),
              ),
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

String _fixZeros(int num) {
  if (num < 10) {
    return '0$num';
  }

  return num.toString();
}
