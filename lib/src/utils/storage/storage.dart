import 'package:get_storage/get_storage.dart';

class WLocalStorage{
  static final WLocalStorage _localStorage = WLocalStorage._internal();

  factory WLocalStorage() {
    return _localStorage;
  }

  WLocalStorage._internal();

  final _storage = GetStorage();

  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  Future<void> clear() async {
    await _storage.erase();
  }

  bool hasData(String key) {
    return _storage.hasData(key);
  }


}