import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DirectorySelector extends StatelessWidget {
  const DirectorySelector({
    Key? key,
    required this.title,
    required this.directory,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final String directory;

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(6)),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Color.fromRGBO(0, 0, 0, .2)),
        ],
      ),
      child: Row(children: [
        Container(
          width: 104,
          margin: const EdgeInsets.only(right: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Text(directory, softWrap: true)),
        TextButton(
          onPressed: pickDirectory,
          child: const Icon(Icons.edit_outlined, size: 20),
          style: TextButton.styleFrom(minimumSize: const Size.square(35)),
        )
      ]),
    );
  }

  pickDirectory() async {
    final directory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select $title',
    );

    if (directory != null) onChanged(directory);
  }
}
