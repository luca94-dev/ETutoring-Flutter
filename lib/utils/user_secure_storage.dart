import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyEmail = 'email';
  static const _keyPassword = 'password';
  static const _keyRole = 'role';
  static const _keyLanguage = 'language';

  static Future setEmail(String email) async =>
      await _storage.write(key: _keyEmail, value: email);

  static Future<String> getEmail() async => await _storage.read(key: _keyEmail);

  static Future setPassword(String password) async =>
      await _storage.write(key: _keyPassword, value: password);

  static Future<String> getPassword() async =>
      await _storage.read(key: _keyPassword);

  static Future setRole(String role) async =>
      await _storage.write(key: _keyRole, value: role);

  static Future<String> getRole() async => await _storage.read(key: _keyRole);

  static Future setLanguage(String language) async =>
      await _storage.write(key: _keyLanguage, value: language);

  static Future<String> getLanguage() async =>
      await _storage.read(key: _keyLanguage);

  static void delete(String key) async => await _storage.delete(key: key);
}
