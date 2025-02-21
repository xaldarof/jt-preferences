import 'dart:async';
import 'package:jt_preferences/src/core/preferences.dart';
import 'package:jt_preferences/src/core/writable.dart';
import 'package:jt_preferences/src/core/write.dart';
import 'package:jt_preferences/src/file/file_manager.dart';
import 'package:jt_preferences/src/models/write_data.dart';

abstract class PreferencesManager extends Preferences
    implements Write<WriteData> {
  Future<bool> writeByCheckConflicts(Writable object);

  Future<void> initialize();
}

class PreferencesManagerImpl extends PreferencesManager {
  final FileManager _manager;
  final StreamController<String> _keyListenerStream =
      StreamController<String>.broadcast();

  late Map<String, dynamic> _cache = {};

  @override
  Future<void> initialize() async {
    _cache = await _manager.read();
  }

  @override
  String? getString(String key) {
    return _cache[key];
  }

  @override
  Future<bool> setInt(String key, int? value) async {
    _cache[key] = value;
    return await write(WriteData(map: _cache, updatedKey: key));
  }

  @override
  int? getInt(String key) {
    return _cache[key] as int?;
  }

  @override
  Future<bool> setString(String key, String? value) async {
    _cache[key] = value;
    return await write(WriteData(map: _cache, updatedKey: key));
  }

  @override
  Future<bool> write(WriteData data) async {
    _keyListenerStream.add(data.updatedKey);
    if (data.map[data.updatedKey] == null) {
      data.map.remove(data.updatedKey);
    }
    await _manager.write(data.map);

    return true;
  }

  PreferencesManagerImpl({
    required FileManager manager,
  }) : _manager = manager;

  @override
  bool? getBoolean(String key) {
    return _cache[key] as bool?;
  }

  @override
  double? getDouble(String key) {
    return _cache[key] as double?;
  }

  @override
  Future<bool> setBool(String key, bool? value) async {
    _cache[key] = value;
    return await write(WriteData(map: _cache, updatedKey: key));
  }

  @override
  Future<bool> setDouble(String key, double? value) async {
    _cache[key] = value;
    return await write(WriteData(map: _cache, updatedKey: key));
  }

  @override
  Stream<String> stream({String? key}) async* {
    await for (final event in _keyListenerStream.stream) {
      if (key != null) {
        if (event == key) {
          yield key;
        }
      } else {
        yield event;
      }
    }
  }

  @override
  bool contains(String key) {
    return _cache.containsKey(key);
  }

  @override
  Future<bool> remove(String key) async {
    _cache.remove(key);
    return await write(WriteData(map: _cache, updatedKey: key));
  }

  @override
  Future<bool> clear() async {
    _cache.clear();
    return write(WriteData(map: _cache, updatedKey: 'null'));
  }

  @override
  Map<String, dynamic> getAll() {
    return _cache;
  }

  @override
  Future<bool> saveObject(Writable data) async {
    return writeByCheckConflicts(data);
  }

  @override
  Future<bool> writeByCheckConflicts(Writable object) async {
    final map = _cache;
    if (map.containsKey(object.key)) {
      if (object.onConflictStrategy == OnConflictStrategy.remove) {
        map.remove(object.key);
        return write(WriteData(map: map, updatedKey: object.key));
      }
      if (object.onConflictStrategy == OnConflictStrategy.update) {
        map[object.key] = object.toJson();
        return write(WriteData(map: map, updatedKey: object.key));
      }
      if (object.onConflictStrategy == OnConflictStrategy.ignore) {
        return true;
      }
    } else {
      map[object.key] = object.toJson();
      return write(WriteData(map: map, updatedKey: object.key));
    }
    return false;
  }

  @override
  T? getObject<T>(String key, T Function(Map<String, dynamic> map) parse) {
    final map = _cache;
    if (map.containsKey(key)) {
      return parse((map[key] as Map<String, dynamic>));
    } else {
      return null;
    }
  }

  @override
  List<String> getKeys() {
    return _cache.keys.toList();
  }

  @override
  Future<void> reload() {
    return initialize();
  }
}
