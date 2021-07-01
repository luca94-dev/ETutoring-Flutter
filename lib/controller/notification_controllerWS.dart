import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/model/notificationTutorModel.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<List<NotificationsTutorModel>> getNotificationsTutorFromWS(
    http.Client client,
    {String email = ''}) async {
  List<NotificationsTutorModel> notificationsList = [];
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
        Uri.https(authority, unencodedPath + "notifications_tutor.php",
            queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      // print(response.body);
      var notificationsJsonData = json.decode(response.body);
      for (var notification in notificationsJsonData) {
        var notificationItem = NotificationsTutorModel.fromJson(notification);
        notificationsList.add(notificationItem);
      }
    }
    return notificationsList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return [];
  }
}

Future<bool> notificationsUpdateCheck(
    http.Client client, notificationsTutorId) async {
  try {
    var data = {
      'notifications_tutor_id': notificationsTutorId,
    };
    var response = await client
        .post(
            Uri.https(
                authority, unencodedPath + 'notifications_tutor_check.php'),
            headers: <String, String>{'authorization': basicAuth},
            body: json.encode(data))
        .timeout(const Duration(seconds: 8));
    // print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}
