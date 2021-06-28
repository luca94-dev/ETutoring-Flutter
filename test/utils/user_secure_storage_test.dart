import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockStorage extends Mock implements UserSecureStorage {
  String email;
  String password;
  String role;

  String getEmail() {
    return email;
  }

  String getPassword() {
    return this.password;
  }

  String getRole() {
    return this.role;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  void setRole(String role) {
    this.role = role;
  }

  void delete(String key) {
    switch (key) {
      case 'email':
        this.email = null;
        break;
      case 'password':
        this.password = null;
        break;
      case 'role':
        this.role = null;
        break;
      default:
        this.email = null;
    }
  }
}

void main() {
  test('get email in storage', () {
    final mockStorage = MockStorage();
    mockStorage.setEmail("davide.decenzo@edu.unito.it");
    expect(mockStorage.getEmail(), "davide.decenzo@edu.unito.it");
  });

  test('get password in storage', () {
    final mockStorage = MockStorage();
    mockStorage.setPassword("test");
    expect(mockStorage.getPassword(), "test");
  });

  test('get role in storage', () {
    final mockStorage = MockStorage();
    mockStorage.setRole("Student");
    expect(mockStorage.getRole(), "Student");
  });

  test('get role in storage but not settings', () {
    final mockStorage = MockStorage();
    expect(mockStorage.getRole(), null);
  });

  test('get role in storage', () {
    final mockStorage = MockStorage();
    mockStorage.setRole("Student");
    expect(mockStorage.getRole(), "Student");
    mockStorage.delete('role');
    expect(mockStorage.getRole(), null);
  });
}
