/*
 * for exec test in terminal
 * flutter test test/controllerWS.dart
 */
import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/controllerWS.dart';
import 'package:e_tutoring/model/courseModel.dart';
import 'package:e_tutoring/model/roleModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'controllerWS.mocks.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
void main() {
  group('getAllCourseFromWS', () {
    test(
        'returns a List of CourseModel if the http call completes successfully',
        () async {
      final client = MockClient();

      when(client.get(Uri.https(authority, unencodedPath + "course_list.php"),
          headers: <String, String>{
            'authorization': basicAuth
          })).thenAnswer((_) async => http.Response(
          '[{"course_id": "3","course_name": "Agenti Intelligenti","course_cfu": "6","enrollment_year": "2021/2022","study_year": "1"}]',
          200));

      List<CourseModel> courseList = await getAllCourseFromWS(client);
      expect(courseList, isA<List<CourseModel>>());
    });

    test('test toString() of first element of List CourseModel', () async {
      final client = MockClient();

      when(client.get(Uri.https(authority, unencodedPath + "course_list.php"),
          headers: <String, String>{
            'authorization': basicAuth
          })).thenAnswer((_) async => http.Response(
          '[{"course_id": "3","course_name": "Agenti Intelligenti","course_cfu": "6","enrollment_year": "2021/2022","study_year": "1"}]',
          200));

      List<CourseModel> courseList = await getAllCourseFromWS(client);
      expect(courseList[0].toString(), "3, Agenti Intelligenti");
    });

    test(
        'if the http call completes with an error 404 return an empty array []',
        () async {
      final client = MockClient();

      when(client.get(Uri.https(authority, unencodedPath + "course_list.php"),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      List<CourseModel> courseList = await getAllCourseFromWS(client);
      expect(courseList, []);
    });

    test(
        'if the http call completes with an error 500 return an empty array []',
        () async {
      final client = MockClient();

      when(client.get(Uri.https(authority, unencodedPath + "course_list.php"),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('Error 500', 500));

      List<CourseModel> courseList = await getAllCourseFromWS(client);
      expect(courseList, []);
    });
  });

  group('getRoleListFromWS', () {
    test(
        'returns a List of DegreeModel if the http call completes successfully',
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

    test(
        'returns a List of DegreeModel if the http call completes successfully',
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

  group('getRoleFromWS', () {
    test(
        'returns a RoleModel of email user if the http call completes successfully',
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
        'returns a RoleModel of email user if the http call completes successfully',
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
        'returns a RoleModel of email user if the http call completes successfully',
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
