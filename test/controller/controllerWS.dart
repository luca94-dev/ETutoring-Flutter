/*
 * for exec test in terminal
 * flutter test test/controllerWS.dart
 */
import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/controllerWS.dart';
import 'package:e_tutoring/model/courseModel.dart';
import 'package:e_tutoring/model/reviewModel.dart';
import 'package:e_tutoring/model/roleModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'controllerWS.mocks.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
void main() {
  /**
   * getAllCourseFromWS
   * GET ALL: restituisce la lista di tutti corsi
   * GET ONE (course_id): restituisce un singolo corso e le relative informazioni 
   */
  getAllCourseFromWSTest();

  /**
   * getRoleListFromWS
   * GET ALL: restituisce la lista di tutti ruoli
   */
  getRoleListFromWSTest();

  /**
   * getRoleFromWS
   * GET ONE ROLE (email): restiuisce un json rappresentate il ruolo di un utente
   */
  getRoleFromWSTest();

  /**
   * getUserCourseSearchFromWS
   * GET (email): restiuisce la lista dei corsi a cui l'utente può richiedere un tutoraggio
   */
  getUserCourseSearchFromWSTest();

  getReviewFromWSTest();
}

getAllCourseFromWSTest() {
  group('getAllCourseFromWS', () {
    test('return a List of CourseModel if the http call completes successfully',
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

getUserCourseSearchFromWSTest() {
  group('getUserCourseSearchFromWS', () {
    test(
        'return a list of CourseModel of email user if the http call completes successfully',
        () async {
      final client = MockClient();

      when(client.get(
        Uri.https(authority, unencodedPath + "course_search.php", {
          'email': "luca.marignati@edu.unito.it",
        }),
        headers: <String, String>{'authorization': basicAuth},
      )).thenAnswer((_) async => http.Response(
          '[{"course_id": "3","course_name": "Agenti Intelligenti","course_cfu": "6","enrollment_year": "2021/2022","study_year": "1"}]',
          200));

      List<CourseModel> courseList = await getUserCourseSearchFromWS(client,
          email: "luca.marignati@edu.unito.it");
      expect(courseList, isA<List<CourseModel>>());
    });

    test(
        'return a list of CourseModel of email user if the http call completes successfully',
        () async {
      final client = MockClient();

      when(client.get(
        Uri.https(authority, unencodedPath + "course_search.php", {
          'email': "luca.marignati@edu.unito.it",
        }),
        headers: <String, String>{'authorization': basicAuth},
      )).thenAnswer((_) async => http.Response(
          '[{"course_id": "3","course_name": "Agenti Intelligenti","course_cfu": "6","enrollment_year": "2021/2022","study_year": "1"}]',
          200));

      List<CourseModel> courseList = await getUserCourseSearchFromWS(client,
          email: "luca.marignati@edu.unito.it");
      expect(courseList[0].course_name, "Agenti Intelligenti");
    });

    test(
        'if the http call completes with an error 404 return an empty array []',
        () async {
      final client = MockClient();

      when(client.get(
              Uri.https(authority, unencodedPath + "course_search.php", {
                'email': "luca.marignati@edu.unito.it",
              }),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      List<CourseModel> courseList = await getUserCourseSearchFromWS(client,
          email: "luca.marignati@edu.unito.it");
      expect(courseList, []);
    });
  });
}

getReviewFromWSTest() {
  group(' getReviewFromWSTest', () {
    test('return a review list if success', () async {
      final client = MockClient();
      var queryParameters = {
        'user_tutor_id': 11,
      };
      when(client.get(
          Uri.https(
              authority, unencodedPath + "review_list.php", queryParameters),
          headers: <String, String>{
            'authorization': basicAuth
          })).thenAnswer((_) async => http.Response(
          '[{"review_id":"1","user_tutor_id":"11","user_id":"1","review_star":"5","review_comment":"Tutor eccellente!","id":"1","username":"luca.marignati","password":"098f6bcd4621d373cade4e832627b4f6","email":"luca.marignati@edu.unito.it","created_at":"2021-05-07 09:15:35","updated_at":"2021-05-07 09:15:35","user_attribute_id":"1","firstname":"Luca","lastname":"Marignati","description":"-","img":null,"badge_number":"779038","cf":"MRGLCU94D02L219F","birth_date":"1994-04-02","birth_city":"Torino","residence_city":"Settimo Torinese","address":"Via Botticelli 2","nationality":"Italiana","gender":"M","phone_number":"3347811074","degree_id":"2","degree_path_id":"1","role_id":"1"}]',
          200));

      List<ReviewModel> reviewList = await getReviewFromWS(client, '11');
      expect(reviewList, isA<List<ReviewModel>>());
    });
  });
}
