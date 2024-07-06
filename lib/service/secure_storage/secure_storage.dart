import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  writeSecureStorage(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readSecureStorage(String key) async {
    String value = await _storage.read(key: key) ?? 'No Data Found!';

    return value;
  }

  deleteSecureStorage(String key) async {
    await _storage.delete(key: key);
  }
}
