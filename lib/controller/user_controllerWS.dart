import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/model/userModel.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<UserModel> getUserInfoFromWS(http.Client client,
    {String email = ''}) async {
  try {
    var queryParameters;
    if (email == null || email.isEmpty) {
      queryParameters = {
        'email': await UserSecureStorage.getEmail(),
      };
    } else {
      queryParameters = {
        'email': email,
      };
    }
    // print(queryParameters);
    var response = await client.get(
        Uri.https(authority, unencodedPath + "users_list.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    var user;
    if (response.statusCode == 200) {
      // print(response.body);
      var userJsonData = json.decode(response.body);
      user = UserModel.fromJson(userJsonData);
      // print(user);
    }
    return user;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}
