import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/model/roleModel.dart';
import 'package:http/http.dart' as http;

Future<List<RoleModel>> getRoleListFromWS(http.Client client) async {
  List<RoleModel> roleList = [];

  try {
    var response = await client.get(
        Uri.https(authority, unencodedPath + "role_list.php"),
        headers: <String, String>{'authorization': basicAuth});
    if (response.statusCode == 200) {
      var roleJsonData = json.decode(response.body);
      for (var roleItem in roleJsonData) {
        var role = RoleModel.fromJson(roleItem);
        roleList.add(role);
      }
    }
    return roleList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return [];
  }
}

Future<RoleModel> getRoleFromWS(http.Client client, String email) async {
  try {
    var queryParameters = {
      'email': email,
    };
    // print(queryParameters);
    var response = await client.get(
        Uri.https(
            authority, unencodedPath + "get_user_role.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    var course;
    if (response.statusCode == 200) {
      // print(response.body);
      var courseJsonData = json.decode(response.body);
      course = RoleModel.fromJson(courseJsonData);
    }
    return course;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}
