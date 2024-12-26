import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final AndroidOptions _androidOptions = const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> writeSecureData(String key, String value) async {
    try {
      await secureStorage.write(
          key: key, value: value, aOptions: _androidOptions);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String?> readSecureData(String key) async {
    try {
      return await secureStorage.read(key: key, aOptions: _androidOptions);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteSecureData(String key) async {
    try {
      await secureStorage.delete(key: key, aOptions: _androidOptions);
    } catch (e) {
      throw Exception(e);
    }
  }
}
