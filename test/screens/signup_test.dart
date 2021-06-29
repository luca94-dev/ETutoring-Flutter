import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/login_controllerWS.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../controller/controllerWS.mocks.dart';

void main() {
  test('signup: email, password, degree_name, degree_type, curriculum, role',
      () async {
    final client = MockClient();

    String email = "user.testing@edu.unito.it";
    String password = "test";
    String degreeName = "Informatica";
    String degreeType = "Laurea Triennale";
    String curriculum = "Informazione e conoscenza";
    String role = "Student";
    var data = {
      'email': email,
      'password': password,
      'degree_name': degreeName,
      'degree_type': degreeType,
      'curriculum': curriculum,
      'role': role
    };

    when(client.post(Uri.https(authority, unencodedPath + 'user_signup.php'),
            headers: <String, String>{'authorization': basicAuth},
            body: json.encode(data)))
        .thenAnswer((_) async =>
            http.Response(jsonEncode('New record created successfully'), 200));

    bool signupResult = await signup(
        client, email, password, degreeName, degreeType, curriculum, role);
    expect(signupResult, true);
  });

  test('login: error 404', () async {
    final client = MockClient();

    String email = "user.testing@edu.unito.it";
    String password = "test";
    String degreeName = "Informatica";
    String degreeType = "Laurea Triennale";
    String curriculum = "Informazione e conoscenza";
    String role = "Student";
    var data = {
      'email': email,
      'password': password,
      'degree_name': degreeName,
      'degree_type': degreeType,
      'curriculum': curriculum,
      'role': role
    };

    when(client.post(Uri.https(authority, unencodedPath + 'user_signup.php'),
            headers: <String, String>{'authorization': basicAuth},
            body: json.encode(data)))
        .thenAnswer((_) async =>
            http.Response(jsonEncode('Error: please Try Again'), 404));

    bool signupResult = await signup(
        client, email, password, degreeName, degreeType, curriculum, role);
    expect(signupResult, false);
  });
}
