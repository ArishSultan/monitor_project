import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

// const _ = {
//   'Yield': ['1|F5'],
//   'Web Profile': ['1|H7'],
//   'Date of Test': ['1|D7'],
//   'ProjectNumber': ['1|F6'],
//   'Coil Thickness': ['1|D5'],
//   'Coil Lot Number': ['1|D6'],
//   'Operation Number': ['1|F7'],
//   'End Time of Test': ['1|H6', '2|H10'],
//   'Bow': ['1|D20', '2|E20', '3|F20', '4|G20', '5|H20'],
//   'Crown': ['1|D18', '2|E18', '3|F18', '4|G18', '5|H18'],
//   'Twist': ['1|D21', '2|E21', '3|F21', '4|G21', '5|H21'],
//   'Camber': ['1|D19', '2|E19', '3|F19', '4|G19', '5|H19'],
//   'Web Width': ['1|D13', '2|E13', '3|F13', '4|G13', '5|H13'],
//   'Flare Far': ['1|D14', '2|E14', '3|F14', '4|G14', '5|H14'],
//   'Flare Near': ['1|D15', '2|E15', '3|F15', '4|G15', '5|H15'],
//   'Part Length': ['1|D12', '2|E12', '3|F12', '4|G12', '5|H12'],
//   'ICCES Number?': ['1|D27', '2|E27', '3|F27', '4|G27', '5|H27'],
//   'Lip Length Far': ['1|D24', '2|E24', '3|F24', '4|G24', '5|H24'],
//   'Label Readable?': ['1|D26', '2|E26', '3|F26', '4|G26', '5|H26'],
//   'Lip Length Near': ['1|D25', '2|E25', '3|F25', '4|G25', '5|H25'],
//   'Flange Width Far': ['1|D22', '2|E22', '3|F22', '4|G22', '5|H22'],
//   'Flange Width Near': ['1|D23', '2|E23', '3|F23', '4|G23', '5|H23'],
//   'Start Time of Test': ['1|H5', '1|D10', '1|E10', '1|F10', '1|G10'],
//   'Hole Location Width': ['1|D16', '2|E16', '3|F16', '4|G16', '5|H16'],
//   'Hole Location Length': ['1|D17', '2|E17', '3|F17', '4|G17', '5|H17'],
// };

const _ = {
  'Yield': ['F5'],
  'Web Profile': ['H7'],
  'Date of Test': ['D7'],
  'ProjectNumber': ['F6'],
  'Coil Thickness': ['D5'],
  'Coil Lot Number': ['D6'],
  'Operation Number': ['F7'],
  'End Time of Test': ['H6', 'H10'],
  'Bow': ['D20', 'E20', 'F20', 'G20', 'H20'],
  'Crown': ['D18', 'E18', 'F18', 'G18', 'H18'],
  'Twist': ['D21', 'E21', 'F21', 'G21', 'H21'],
  'Camber': ['D19', 'E19', 'F19', 'G19', 'H19'],
  'Web Width': ['D13', 'E13', 'F13', 'G13', 'H13'],
  'Flare Far': ['D14', 'E14', 'F14', 'G14', 'H14'],
  'Flare Near': ['D15', 'E15', 'F15', 'G15', 'H15'],
  'Part Length': ['D12', 'E12', 'F12', 'G12', 'H12'],
  'ICCES Number?': ['D27', 'E27', 'F27', 'G27', 'H27'],
  'Lip Length Far': ['D24', 'E24', 'F24', 'G24', 'H24'],
  'Label Readable?': ['D26', 'E26', 'F26', 'G26', 'H26'],
  'Lip Length Near': ['D25', 'E25', 'F25', 'G25', 'H25'],
  'Flange Width Far': ['D22', 'E22', 'F22', 'G22', 'H22'],
  'Flange Width Near': ['D23', 'E23', 'F23', 'G23', 'H23'],
  'Start Time of Test': ['H5', 'D10', 'E10', 'F10', 'G10'],
  'Hole Location Width': ['D16', 'E16', 'F16', 'G16', 'H16'],
  'Hole Location Length': ['D17', 'E17', 'F17', 'G17', 'H17'],
};

Future<Excel> readTemplateFile() async => Excel.decodeBytes(
    (await rootBundle.load('assets/template.xlsx')).buffer.asInt8List());

Future<void> createPDF(String path, String outputPath) async {
  final template = await readTemplateFile();
  final inputCsv = const CsvToListConverter().convert(
    await File(path).readAsString(),
  );

  for (final item in inputCsv) {
    final placeholders = _[item.first];
    final values = item.sublist(1);

    if (placeholders!.length != values.length) {
      continue;
      // throw 'Input file is not correct, ${item.first} required '
      //     '${placeholders.length} values but ${values.length} values were provided.';
    }

    for (int i = 0; i < placeholders.length; ++i) {
      template.updateCell(
        'Form',
        CellIndex.indexByString(placeholders[i]),
        values[i],
      );

      File(join(outputPath, basenameWithoutExtension(path) + '.xlsx'))
          .writeAsBytes(template.save()!);
    }
  }
}
