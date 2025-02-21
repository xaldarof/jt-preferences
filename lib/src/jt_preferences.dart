import 'package:jt_preferences/src/core/preferences.dart';
import 'package:jt_preferences/src/core/writable.dart';
import 'package:jt_preferences/src/di/lib_di.dart';

import 'preferences_manager.dart';

class JtPreferences extends Preferences {
  JtPreferences._();

  static late final PreferencesManager _manager;
  static final JtPreferences _instance = JtPreferences._();

  static JtPreferences getInstance() {
    return _instance;
  }

  static Future<void> initialize(String path, {String? encryptionKey}) async {
    initDependencies(path, encryptionKey: encryptionKey);
    _manager = injector.get<PreferencesManager>();
    await _manager.initialize();
  }

  @override
  Future<bool> setInt(String key, int? value) {
    return _manager.setInt(key, value);
  }

  @override
  Future<bool> setString(String key, String? value) {
    return _manager.setString(key, value);
  }

  @override
  int? getInt(String key) {
    return _manager.getInt(key);
  }

  @override
  String? getString(String key) {
    return _manager.getString(key);
  }

  @override
  bool? getBoolean(String key) {
    return _manager.getBoolean(key);
  }

  @override
  double? getDouble(String key) {
    return _manager.getDouble(key);
  }

  @override
  Future<bool> setBool(String key, bool? value) {
    return _manager.setBool(key, value);
  }

  @override
  Future<bool> setDouble(String key, double? value) {
    return _manager.setDouble(key, value);
  }

  @override
  Stream<String> stream({String? key}) {
    return _manager.stream(key: key);
  }

  @override
  bool contains(String key) {
    return _manager.contains(key);
  }

  @override
  Future<bool> remove(String key) {
    return _manager.remove(key);
  }

  @override
  Future<bool> clear() {
    return _manager.clear();
  }

  @override
  Map<String, dynamic> getAll() {
    return _manager.getAll();
  }

  @override
  Future<bool> saveObject(Writable data) {
    return _manager.saveObject(data);
  }

  @override
  T? getObject<T>(String key, T Function(Map<String, dynamic> map) parse) {
    return _manager.getObject(key, parse);
  }

  @override
  List<String> getKeys() {
    return _manager.getKeys();
  }

  @override
  Future<void> reload() => _manager.reload();
}
