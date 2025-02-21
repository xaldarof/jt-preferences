import 'writable.dart';

abstract class Preferences implements Set, Get, Clear, StreamListener {}

abstract class Set {
  Future<bool> setString(String key, String? value);

  Future<bool> setInt(String key, int? value);

  Future<bool> setDouble(String key, double? value);

  Future<bool> setBool(String key, bool? value);

  Future<bool> remove(String key);

  Future<bool> saveObject(Writable data);
}

abstract class Clear {
  Future<bool> clear();
}

abstract class Get {
  String? getString(String key);

  int? getInt(String key);

  double? getDouble(String key);

  bool? getBoolean(String key);

  bool contains(String key);

  Map<String, dynamic> getAll();

  List<String> getKeys();

  Future<void> reload();

  T? getObject<T>(String key, T Function(Map<String, dynamic> map) parse);
}

abstract class StreamListener<T> {
  Stream<String> stream({String? key});
}
