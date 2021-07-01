/*
 * for exec test in terminal
 * flutter test test/controllerWS.dart
 */
import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/user_controllerWS.dart';
import 'package:e_tutoring/model/userModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'controllerWS.mocks.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
void main() {
  /**
   * getUserInfoFromWS
   * https://www.e-tutoring-app.it/ws/users_list.php?email=luca.marignati@edu.unito.it
   */
  getUserInfoFromWSTest();
}

getUserInfoFromWSTest() {
  group('getUserInfoFromWS', () {
    test('return a UserModel if the http call completes successfully',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': 'luca.marignati@edu.unito.it',
      };
      when(client.get(
              Uri.https(
                  authority, unencodedPath + "users_list.php", queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('''{
"id": "1",
"username": "luca.marignati",
"password": "098f6bcd4621d373cade4e832627b4f6",
"email": "luca.marignati@edu.unito.it",
"created_at": "2021-05-07 09:15:35",
"updated_at": "2021-05-07 09:15:35",
"user_attribute_id": "1",
"firstname": "Luca",
"lastname": "Marignati",
"description": "-",
"img": null,
"badge_number": "779038",
"cf": "MRGLCU94D02L219F",
"birth_date": "1994-04-02",
"birth_city": "Torino",
"residence_city": "Settimo Torinese",
"address": "Via Botticelli 2",
"nationality": "Italiana",
"gender": "M",
"phone_number": "3347811074",
"degree_id": "2",
"degree_path_id": "1",
"role_id": "1",
"user_id": "1",
"role_name": "Student",
"role_description": "Student",
"degree_name": "Informatica",
"degree_cfu": "120",
"degree_description": "",
"degree_type_id": "2",
"degree_location": "Torino",
"degree_athenaeum": "Unito",
"degree_path_name": "Intelligenza Artificiale e Sistemi Informatici Pietro Torasso",
"degree_path_description": "Intelligenza Artificiale e Sistemi Informatici Pietro Torasso",
"degree_path_note": "per studenti iscritti dal 2017/2018",
"degree_type_name": "LM",
"degree_type_note": "Laurea Magistrale"
}''', 200));
      UserModel user =
          await getUserInfoFromWS(client, email: "luca.marignati@edu.unito.it");
      expect(user, isA<UserModel>());
      expect(user.id, "1");
      expect(user.username, "luca.marignati");
      expect(user.firstname, "Luca");
      expect(user.lastname, "Marignati");
      expect(user.badge_number, "779038");
      expect(user.birth_city, "Torino");
      expect(user.residence_city, "Settimo Torinese");
      expect(user.role_name, "Student");
      expect(user.degree_name, "Informatica");
      expect(user.degree_path_name,
          "Intelligenza Artificiale e Sistemi Informatici Pietro Torasso");
      expect(user.degree_type_name, "LM");
      expect(user.degree_type_note, "Laurea Magistrale");
    });

    test('if the http call completes with an error 404 return null', () async {
      final client = MockClient();

      var queryParameters = {
        'email': 'luca.marignati@edu.unito.it',
      };
      when(client.get(
              Uri.https(
                  authority, unencodedPath + "users_list.php", queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('Not found', 404));

      UserModel user =
          await getUserInfoFromWS(client, email: "luca.marignati@edu.unito.it");
      expect(user, null);
    });
  });
}
