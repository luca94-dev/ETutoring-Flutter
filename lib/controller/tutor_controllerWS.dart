import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/model/tutorModel.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<List<TutorModel>> getTutorSearchFromWS(http.Client client) async {
  List<TutorModel> tutorList = [];
  try {
    var response = await client.get(
        Uri.https(authority, unencodedPath + "tutor_list.php"),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      // print(response.body);
      var tutorJsonData = json.decode(response.body);
      //  print(tutorJsonData);
      for (var item in tutorJsonData) {
        // print(item['id']);
        var tutorItem = TutorModel.fromJson(item);
        tutorList.add(tutorItem);
      }
      // print(tutorList);
    }
    return tutorList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<TutorModel> getTutorDetailFromWS(http.Client client,
    {String email}) async {
  try {
    var queryParameters;
    if (email == null) {
      queryParameters = {
        'email': await UserSecureStorage.getEmail(),
      };
    } else {
      queryParameters = {
        'email': email,
      };
    }
    var tutorItem;
    var response = await client.get(
        Uri.https(authority, unencodedPath + "tutor_list.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var tutorJsonData = json.decode(response.body);
      tutorItem = TutorModel.fromJson(tutorJsonData);
    }
    return tutorItem;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}
