import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  test('empty email return error', () async {
    // unit test
    var result = EmailValidator.validate('');
    expect(false, result);
  });

  test('not email return error', () async {
    // unit test
    var result = EmailValidator.validate('email not valid');
    expect(false, result);
  });

  test('email returns true', () async {
    // unit test
    var result = EmailValidator.validate('paolo.rossi@edu.unito.it');
    expect(true, result);
  });
}
