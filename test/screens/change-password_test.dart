import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/login_controllerWS.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:http/http.dart' as http;

import '../controller/controllerWS.mocks.dart';

void main() {
  test('change password', () async {
    final client = MockClient();

    String email = "simone.bortolotti@edu.unito.it";
    String password = "newPassword";
    var data = {'email': email, 'password': password};

    when(client.post(
            Uri.https(authority, unencodedPath + 'user_change_password.php'),
            headers: <String, String>{'authorization': basicAuth},
            body: json.encode(data)))
        .thenAnswer((_) async =>
            http.Response(jsonEncode('Password updated successfully'), 200));

    String changegePWDResult = await changePassword(client, email, password);
    expect(changegePWDResult, "Password updated successfully");
  });

  test('change password', () async {
    final client = MockClient();

    String email = "simone.bortolotti@edu.unito.it";
    String password = "newPassword";
    var data = {'email': email, 'password': password};

    when(client.post(
            Uri.https(authority, unencodedPath + 'user_change_password.php'),
            headers: <String, String>{'authorization': basicAuth},
            body: json.encode(data)))
        .thenAnswer((_) async =>
            http.Response(jsonEncode('Error updating password'), 404));

    String changegePWDResult = await changePassword(client, email, password);
    expect(changegePWDResult, "Error updating password");
  });
}
