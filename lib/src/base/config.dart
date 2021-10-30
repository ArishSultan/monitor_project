import 'dart:io';
import 'dart:convert';

import 'package:path/path.dart';
import 'package:flutter/material.dart';

class AppConfig extends ChangeNotifier {
  AppConfig._(this._inputDirectory, this._outputDirectory);

  Directory get inputDirectory => _inputDirectory;

  set inputDirectory(Directory dir) {
    _inputDirectory = dir;
    notifyListeners();

    _configFile.writeAsString(
      '{"inputDirectory": "${inputDirectory.path}",'
      '"outputDirectory": "${outputDirectory.path}"}',
    );
  }

  Directory get outputDirectory => _outputDirectory;

  set outputDirectory(Directory dir) {
    _outputDirectory = dir;
    notifyListeners();

    _configFile.writeAsString(
      '{"inputDirectory": "${inputDirectory.path}",'
      '"outputDirectory": "${outputDirectory.path}"}',
    );
  }

  static AppConfig get instance => _instance;

  static Future<void> initialize() async {
    _configFile = File(join(Directory.systemTemp.path, 'monitor_config.json'));

    if (!(await _configFile.exists())) {
      await _configFile.create();
      _configFile.writeAsString(
        '{"inputDirectory": "${Directory.current}",'
        '"outputDirectory": "${Directory.current}"}',
      );

      _instance = AppConfig._(Directory.current, Directory.current);
    } else {
      final _json = jsonDecode(await _configFile.readAsString());

      _instance = AppConfig._(
        Directory(_json['inputDirectory'] ?? Directory.current.path),
        Directory(_json['outputDirectory'] ?? Directory.current.path),
      );
    }
  }

  Directory _inputDirectory;
  Directory _outputDirectory;

  static late File _configFile;
  static late final AppConfig _instance;
}
