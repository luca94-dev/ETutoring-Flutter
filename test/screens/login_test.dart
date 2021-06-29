import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/controllerWS.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:http/http.dart' as http;

import '../controller/controllerWS.mocks.dart';

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

  test('login: verify email and password', () async {
    final client = MockClient();

    String email = "simone.bortolotti@edu.unito.it";
    String password = "errore";
    var data = {'email': email, 'password': password};

    when(client.post(Uri.https(authority, unencodedPath + 'user_login.php'),
            headers: <String, String>{'authorization': basicAuth},
            body: json.encode(data)))
        .thenAnswer((_) async => http.Response(
            'Invalid Username or Password Please Try Again', 200));

    bool loginResult = await login(client, email, password);
    expect(loginResult, false);
  });

  test('login: verify email and password', () async {
    final client = MockClient();

    String email = "simone.bortolotti@edu.unito.it";
    String password = "test";
    var data = {'email': email, 'password': password};

    when(client.post(Uri.https(authority, unencodedPath + 'user_login.php'),
            headers: <String, String>{'authorization': basicAuth},
            body: json.encode(data)))
        .thenAnswer((_) async => http.Response('Login Matched', 200));

    bool loginResult = await login(client, email, password);
    expect(loginResult, true);
  });

  test('login: verify email and password', () async {
    final client = MockClient();

    String email = "davide.decenzo@edu.unito.it";
    String password = "errore";
    var data = {'email': email, 'password': password};

    when(client.post(Uri.https(authority, unencodedPath + 'user_login.php'),
            headers: <String, String>{'authorization': basicAuth},
            body: json.encode(data)))
        .thenAnswer((_) async => http.Response(
            'Invalid Username or Password Please Try Again', 200));

    bool loginResult = await login(client, email, password);
    expect(loginResult, false);
  });
}
