import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/model/tutorLesson.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<List<TutorLessonModel>> getTutorLessonFromWS(http.Client client,
    {String email = ''}) async {
  List<TutorLessonModel> lessonList = [];
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

    var response = await client.get(
        Uri.https(authority, unencodedPath + "tutor_lesson_list.php",
            queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      // print(response.body);
      var lessonJsonData = json.decode(response.body);
      //  print(tutorJsonData);
      for (var lesson in lessonJsonData) {
        // print(item['id']);
        var tutorItem = TutorLessonModel.fromJson(lesson);
        lessonList.add(tutorItem);
      }
      // print(tutorList);
    }
    return lessonList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<List<TutorLessonModel>> getTutorLessonTodayFromWS(http.Client client,
    {String email = ''}) async {
  List<TutorLessonModel> lessonList = [];
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

    var response = await client.get(
        Uri.https(authority, unencodedPath + "tutor_lesson_today_list.php",
            queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      // print(response.body);
      var lessonJsonData = json.decode(response.body);
      //  print(tutorJsonData);
      for (var lesson in lessonJsonData) {
        // print(item['id']);
        var tutorItem = TutorLessonModel.fromJson(lesson);
        lessonList.add(tutorItem);
      }
      // print(tutorList);
    }
    return lessonList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}
