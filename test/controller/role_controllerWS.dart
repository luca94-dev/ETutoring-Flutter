/*
 * for exec test in terminal
 * flutter test test/controllerWS.dart
 */
import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/role_controllerWS.dart';
import 'package:e_tutoring/model/roleModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'controllerWS.mocks.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
void main() {
  /**
   * getRoleListFromWS
   * GET ALL: restituisce la lista di tutti ruoli
   * https://www.e-tutoring-app.it/ws/role_list.php
   */
  getRoleListFromWSTest();

  /**
   * getRoleFromWS
   * GET ONE ROLE (email): restiuisce un json rappresentate il ruolo di un utente
   * https://www.e-tutoring-app.it/ws/get_user_role.php?email=paolo.rossi@edu.unito.it
   * https://www.e-tutoring-app.it/ws/get_user_role.php?email=luca.marignati@edu.unito.it
   */
  getRoleFromWSTest();
}

getRoleListFromWSTest() {
  group('getRoleListFromWS', () {
    test('return a List of DegreeModel if the http call completes successfully',
        () async {
      final client = MockClient();

      when(client.get(Uri.https(authority, unencodedPath + "role_list.php"),
          headers: <String, String>{
            'authorization': basicAuth
          })).thenAnswer((_) async => http.Response(
          '[{"role_id": "1","role_name": "Student","role_description": "Student"}]',
          200));

      List<RoleModel> roleList = await getRoleListFromWS(client);
      expect(roleList, isA<List<RoleModel>>());
    });

    test('return a List of DegreeModel if the http call completes successfully',
        () async {
      final client = MockClient();

      when(client.get(Uri.https(authority, unencodedPath + "role_list.php"),
          headers: <String, String>{
            'authorization': basicAuth
          })).thenAnswer((_) async => http.Response(
          '[{"role_id": "1","role_name": "Student","role_description": "Student"}]',
          200));

      List<RoleModel> roleList = await getRoleListFromWS(client);
      expect("1", roleList[0].role_id);
      expect("Student", roleList[0].role_name);
      expect(roleList[0], isA<RoleModel>());
    });

    test(
        'if the http call completes with an error 404 return an empty array []',
        () async {
      final client = MockClient();

      when(client.get(Uri.https(authority, unencodedPath + "role_list.php"),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      List<RoleModel> roleList = await getRoleListFromWS(client);
      expect(roleList, []);
    });
  });
}

getRoleFromWSTest() {
  group('getRoleFromWS', () {
    test(
        'return a RoleModel of email user if the http call completes successfully',
        () async {
      final client = MockClient();

      when(client.get(
        Uri.https(authority, unencodedPath + "get_user_role.php", {
          'email': "luca.marignati@edu.unito.it",
        }),
        headers: <String, String>{'authorization': basicAuth},
      )).thenAnswer((_) async => http.Response(
          '{"role_id": "1","role_name": "Student","role_description": "Student"}',
          200));

      RoleModel role =
          await getRoleFromWS(client, "luca.marignati@edu.unito.it");

      expect(role, isA<RoleModel>());
    });

    test(
        'return a RoleModel of email user if the http call completes successfully',
        () async {
      final client = MockClient();

      when(client.get(
        Uri.https(authority, unencodedPath + "get_user_role.php", {
          'email': "simone.bortolotti@edu.unito.it",
        }),
        headers: <String, String>{'authorization': basicAuth},
      )).thenAnswer((_) async => http.Response(
          '{"role_id": "1","role_name": "Student","role_description": "Student"}',
          200));

      RoleModel role =
          await getRoleFromWS(client, "simone.bortolotti@edu.unito.it");

      expect(role.role_name, "Student");
    });

    test(
        'return a RoleModel of email user if the http call completes successfully',
        () async {
      final client = MockClient();

      when(client.get(
        Uri.https(authority, unencodedPath + "get_user_role.php", {
          'email': "paolo.rossi@edu.unito.it",
        }),
        headers: <String, String>{'authorization': basicAuth},
      )).thenAnswer((_) async => http.Response(
          '{"role_id": "2","role_name": "Tutor","role_description": "Tutor"}',
          200));

      RoleModel role = await getRoleFromWS(client, "paolo.rossi@edu.unito.it");

      expect(role.role_name, "Tutor");
    });

    test(
        'if the http call completes with an error 404 return an empty array []',
        () async {
      final client = MockClient();

      when(client.get(
        Uri.https(authority, unencodedPath + "get_user_role.php", {
          'email': "luca.marignati@edu.unito.it",
        }),
        headers: <String, String>{'authorization': basicAuth},
      )).thenAnswer((_) async => http.Response('Not found', 404));

      RoleModel role =
          await getRoleFromWS(client, "luca.marignati@edu.unito.it");
      expect(role, null);
    });
  });
}
