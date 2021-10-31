import 'dart:io';
import 'dart:convert';

import 'package:path/path.dart';
import 'package:flutter/material.dart';

class AppConfig extends ChangeNotifier {
  AppConfig._(this._inputDirectory, this._outputDirectory);

  bool get isWatching => _isWatching;

  set isWatching(bool value) {
    _isWatching = value;
    notifyListeners();
  }

  Directory get inputDirectory => _inputDirectory;

  set inputDirectory(Directory dir) {
    _inputDirectory = dir;
    notifyListeners();

    _configFile.writeAsString(
      '{"inputDirectory": "${inputDirectory.path.replaceAll(r'\', r'\\')}",'
      '"outputDirectory": "${outputDirectory.path.replaceAll(r'\', r'\\')}"}',
    );
  }

  Directory get outputDirectory => _outputDirectory;

  set outputDirectory(Directory dir) {
    _outputDirectory = dir;
    notifyListeners();

    _configFile.writeAsString(
      '{"inputDirectory": "${inputDirectory.path.replaceAll(r'\', r'\\')}",'
      '"outputDirectory": "${outputDirectory.path.replaceAll(r'\', r'\\')}"}',
    );
  }

  static AppConfig get instance => _instance;

  static Future<void> initialize() async {
    _configFile = File(join(Directory.systemTemp.path, 'monitor_config.json'));

    if (!(await _configFile.exists())) {
      await _configFile.create();
      _configFile.writeAsString(
        '{"inputDirectory": "${Directory.current.path.replaceAll(r'\', r'\\')}",'
        '"outputDirectory": "${Directory.current.path.replaceAll(r'\', r'\\')}"}',
      );

      _instance = AppConfig._(Directory.current, Directory.current);
    } else {
      Map<String, dynamic>? _json;
      try {
        _json = jsonDecode(await _configFile.readAsString());
      } catch (e) {
        /// Some task.
      }

      _instance = AppConfig._(
        Directory(_json?['inputDirectory'] ?? Directory.current.path),
        Directory(_json?['outputDirectory'] ?? Directory.current.path),
      );
    }
  }

  bool _isWatching = false;
  Directory _inputDirectory;
  Directory _outputDirectory;

  static late File _configFile;
  static late final AppConfig _instance;
}
