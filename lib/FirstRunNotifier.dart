import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';

class FirstRun extends ChangeNotifier {
  bool _firstRun = true;
  bool get firstRun => _firstRun;
  void setFirstRun(bool value) {
    _firstRun = value;
    notifyListeners();
  }

  FirstRun();

  Future<void> checkFirstRun() async {
    _firstRun = await IsFirstRun.isFirstRun();
    notifyListeners();
  }
}

class UpdateChecker {
  late String _storedValue;
  bool _update = false;
  bool get update => _update;

  Future<String> getStoredValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _storedValue = prefs.getString('build_version') ?? '';
    return _storedValue;
  }

  Future<String> getCurrentValue() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  }

  // Store value in shared preferences
  void _storeValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('build_version', value);
  }

  //Check if the current version is the same as the stored version
  Future<bool> _checkVersion() async {
    String storedValue = await getStoredValue();
    String currentValue = await getCurrentValue();
    if (storedValue == currentValue) {
      return false;
    } else {
      _storeValue(currentValue);
      return true;
    }
  }
}
