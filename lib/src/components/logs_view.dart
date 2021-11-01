import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Log {
  Log._(this._data) : _time = DateTime.now();

  final String _data;
  final DateTime _time;

  Widget toWidget() {
    final day = _fixZeros(_time.day);
    final hour = _fixZeros(_time.hour);
    final year = _fixZeros(_time.year);
    final month = _fixZeros(_time.month);
    final minute = _fixZeros(_time.minute);
    final second = _fixZeros(_time.second);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          '* [$year-$month-$day $hour:$minute:$second] - ',
          style: const TextStyle(fontFamily: 'Cascadia Code', fontSize: 10),
        ),
        Expanded(
          child: Text(
            _data,
            style: const TextStyle(fontFamily: 'Cascadia Code', fontSize: 10),
          ),
        ),
      ]),
    );
  }
}

class LogsController extends ChangeNotifier {
  final _logs = <Log>[];

  void addLog(String text) {
    _logs.add(Log._(text));
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
          return widget.controller._logs[index].toWidget();
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
