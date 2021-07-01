import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/notification_controllerWS.dart';
import 'package:e_tutoring/model/notificationTutorModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'controllerWS.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  getNotificationsTutorFromWSTest();

  notificationsUpdateCheckTest();
}

getNotificationsTutorFromWSTest() {
  group('getNotificationsTutorFromWS', () {
    test(
        'return a List of NotificationsTutorModel if the http call completes successfully',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': 'davide.decenzo@edu.unito.it',
      };
      when(client.get(
              Uri.https(authority, unencodedPath + "notifications_tutor.php",
                  queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('''
          [{"notifications_tutor_id": "1",
           "date": "18/07/2021",
		        "check": "Si",
            "degree_description": "Corso di Apprendimento Automatico",
		        "tutor_course_id": "1",
		        "day": "15",
	        	"hour_from": "16:00",
		        "hour_to": "18:00",
		        "course_id": "17771",
            "course_name": "Apprendimento Automatico",
            "course_cfu": "9",
            "department": "Informatica",
            "student": "Luca Marignati"
	        }]''', 200));

      List<NotificationsTutorModel> notificationsList =
          await getNotificationsTutorFromWS(client,
              email: 'davide.decenzo@edu.unito.it');
      expect(notificationsList, isA<List<NotificationsTutorModel>>());
    });

    test(
        'return a List of NotificationsTutorModel if the http call completes successfully',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': 'davide.decenzo@edu.unito.it',
      };
      when(client.get(
              Uri.https(authority, unencodedPath + "notifications_tutor.php",
                  queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('''
          [{"notifications_tutor_id": "1",
           "date": "18/07/2021",
		        "check": "Si",
            "degree_description": "Corso di Apprendimento Automatico",
		        "tutor_course_id": "1",
		        "day": "15",
	        	"hour_from": "16:00",
		        "hour_to": "18:00",
		        "course_id": "17771",
            "course_name": "Apprendimento Automatico",
            "course_cfu": "9",
            "department": "Informatica",
            "student": "Luca Marignati"
	        }]''', 200));

      List<NotificationsTutorModel> notificationsList =
          await getNotificationsTutorFromWS(client,
              email: 'davide.decenzo@edu.unito.it');
      expect(notificationsList.length, 1);
      expect(notificationsList[0], isA<NotificationsTutorModel>());
      expect(notificationsList[0].notifications_tutor_id, "1");
      expect(notificationsList[0].course_name, "Apprendimento Automatico");
      expect(notificationsList[0].course_id, "17771");
      expect(notificationsList[0].student, "Luca Marignati");
    });
    test(
        'return an empty List of NotificationsTutorModel if the http call completes with fails: error 404',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': 'davide.decenzo@edu.unito.it',
      };
      when(client.get(
              Uri.https(authority, unencodedPath + "notifications_tutor.php",
                  queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      List<NotificationsTutorModel> notificationsList =
          await getNotificationsTutorFromWS(client,
              email: 'davide.decenzo@edu.unito.it');
      expect(notificationsList.length, 0);
      expect(notificationsList, []);
    });
  });
}

notificationsUpdateCheckTest() {
  group('notificationsUpdateCheck', () {
    test('return a true if update check field is completes successfully',
        () async {
      final client = MockClient();
      var data = {
        'notifications_tutor_id': 1,
      };

      when(client.post(
              Uri.https(
                  authority, unencodedPath + 'notifications_tutor_check.php'),
              headers: <String, String>{'authorization': basicAuth},
              body: json.encode(data)))
          .thenAnswer((_) async =>
              http.Response('{"Check updated successfully"}', 200));

      bool response = await notificationsUpdateCheck(client, 1);
      expect(response, true);
    });

    test(
        'return a false if update check field is completes with fails: error 404',
        () async {
      final client = MockClient();
      var data = {
        'notifications_tutor_id': 1,
      };

      when(client.post(
              Uri.https(
                  authority, unencodedPath + 'notifications_tutor_check.php'),
              headers: <String, String>{'authorization': basicAuth},
              body: json.encode(data)))
          .thenAnswer((_) async => http.Response('Not found', 404));

      bool response = await notificationsUpdateCheck(client, 1);
      expect(response, false);
    });
  });
}
