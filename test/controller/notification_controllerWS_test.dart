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
  });
}
