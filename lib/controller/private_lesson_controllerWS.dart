import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/model/privatelessonModel.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<List<PrivatelessonModel>> getPrivateLessonFromWS(http.Client client,
    {String email = ''}) async {
  List<PrivatelessonModel> lessonList = [];
  var queryParameters;
  try {
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
        Uri.https(authority, unencodedPath + "private_lesson_list.php",
            queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var lessonJsonData = json.decode(response.body);
      for (var item in lessonJsonData) {
        var lessonItem = PrivatelessonModel.fromJson(item);
        lessonList.add(lessonItem);
      }
    }
    return lessonList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<List<PrivatelessonModel>> getPrivateLessonTodayFromWS(http.Client client,
    {String email = ''}) async {
  List<PrivatelessonModel> lessonList = [];
  var queryParameters;
  try {
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
        Uri.https(authority, unencodedPath + "private_lesson_today_list.php",
            queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var lessonJsonData = json.decode(response.body);
      for (var item in lessonJsonData) {
        var lessonItem = PrivatelessonModel.fromJson(item);
        lessonList.add(lessonItem);
      }
    }
    return lessonList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}
