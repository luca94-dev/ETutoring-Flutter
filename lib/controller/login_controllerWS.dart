import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:http/http.dart' as http;

Future<bool> login(http.Client client, String email, String password) async {
  var data = {'email': email, 'password': password};
  // Starting Web API Call.
  // https method: POST
  var response = await client
      .post(Uri.https(authority, unencodedPath + 'user_login.php'),
          headers: <String, String>{'authorization': basicAuth},
          body: json.encode(data))
      .timeout(const Duration(seconds: 8));

  if (response.statusCode == 200) {
    var message = jsonDecode(response.body);

    // If the Response Message is Matched.
    if (message == 'Login Matched') {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<bool> signup(
    http.Client client,
    String email,
    String password,
    String degreeName,
    String degreeType,
    String curriculum,
    String role) async {
  var data = {
    'email': email,
    'password': password,
    'degree_name': degreeName,
    'degree_type': degreeType,
    'curriculum': curriculum,
    'role': role
  };
  var response = await client
      .post(Uri.https(authority, unencodedPath + 'user_signup.php'),
          headers: <String, String>{'authorization': basicAuth},
          body: json.encode(data))
      .timeout(const Duration(seconds: 8));

  var message = jsonDecode(response.body);
  // print(response.body);
  if (response.statusCode == 200) {
    if (message == 'New record created successfully') {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<String> changePassword(
    http.Client client, String email, String password) async {
  var data = {'email': email, 'password': password};
  var response = await client
      .post(
        Uri.https(authority, unencodedPath + 'user_change_password.php'),
        headers: <String, String>{'authorization': basicAuth},
        body: json.encode(data),
      )
      .timeout(const Duration(seconds: 8));

  if (response.statusCode == 200) {
    var message = jsonDecode(response.body);
    return message;
  } else {
    return "Error updating password";
  }
}
