import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/model/courseModel.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<List<CourseModel>> getUserCourseSearchFromWS(http.Client client,
    {String searchString = '', String email = ''}) async {
  List<CourseModel> courseList = [];
  var queryParameters;
  try {
    if (email.isEmpty || email == null) {
      queryParameters = {
        'email': await UserSecureStorage.getEmail(),
      };

      if (searchString != '') {
        queryParameters = {
          'email': await UserSecureStorage.getEmail(),
          'query': searchString,
        };
      }
    } else {
      queryParameters = {
        'email': email,
      };

      if (searchString != '') {
        queryParameters = {
          'email': email,
          'query': searchString,
        };
      }
    }
    // print(queryParameters);

    var response = await client.get(
        Uri.https(
            authority, unencodedPath + "course_search.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});
    if (response.statusCode == 200) {
      // print(response.body);
      var courseJsonData = json.decode(response.body);
      // print(courseJsonData);
      for (var courseItem in courseJsonData) {
        var course = CourseModel.fromJson(courseItem);
        // print(course);
        courseList.add(course);
      }
    }
    return courseList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return [];
  }
}

Future<List<CourseModel>> getAllCourseFromWS(http.Client client) async {
  List<CourseModel> courseList = [];

  try {
    var response = await client.get(
        Uri.https(authority, unencodedPath + "course_list.php"),
        headers: <String, String>{'authorization': basicAuth});
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var courseJsonData = json.decode(response.body);
      for (var courseItem in courseJsonData) {
        var course = CourseModel.fromJson(courseItem);
        courseList.add(course);
      }
    }
    return courseList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return [];
  }
}

Future<CourseModel> getCourseDetailFromWS(
    http.Client client, String courseId) async {
  try {
    var queryParameters = {
      'course_id': courseId,
    };
    // print(queryParameters);
    var response = await client.get(
        Uri.https(
            authority, unencodedPath + "course_list.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    var course;
    if (response.statusCode == 200) {
      // print(response.body);
      var courseJsonData = json.decode(response.body);
      course = CourseModel.fromJson(courseJsonData);
      // print(user);
    }
    return course;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}
