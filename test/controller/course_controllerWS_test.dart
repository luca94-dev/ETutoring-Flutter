import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/course_controllerWS.dart';
import 'package:e_tutoring/model/courseModel.dart';
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
   * https://www.e-tutoring-app.it/ws/course_list.php
   * https://www.e-tutoring-app.it/ws/course_list.php?course_id=1
   */
  getAllCourseFromWSTest();

  /**
   * getUserCourseSearchFromWS
   * GET (email): restiuisce la lista dei corsi a cui l'utente può richiedere un tutoraggio
   * https://www.e-tutoring-app.it/ws/course_search.php?email=luca.marignati@edu.unito.it
   * https://www.e-tutoring-app.it/ws/course_search.php?email=simone.bortolotti@edu.unito.it
   */
  getUserCourseSearchFromWSTest();

  /** 
   * getCourseDetailFromWS
   * https://www.e-tutoring-app.it/ws/course_list.php?course_id=5
   * get detail of course
   */
  getCourseDetailFromWSTest();
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
      expect(courseList.length, 1);
      expect(courseList[0], isA<CourseModel>());
      expect(courseList[0].toString(), "3, Agenti Intelligenti");
      expect(courseList[0].course_id, "3");
      expect(courseList[0].course_name, "Agenti Intelligenti");
      expect(courseList[0].course_cfu, "6");
      expect(courseList[0].enrollment_year, "2021/2022");
      expect(courseList[0].study_year, "1");
      expect(courseList[0].selected, false);
      expect(courseList[0].ssd, "-");
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
      expect(courseList.length, 0);
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
      expect(courseList.length, 0);
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
      expect(courseList[0], isA<CourseModel>());
      expect(courseList[0].course_name, "Agenti Intelligenti");
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
      expect(courseList.length, 1);
      expect(courseList[0], isA<CourseModel>());
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

getCourseDetailFromWSTest() {
  group('getCourseDetailFromWS', () {
    test('return a CourseModel if the http call completes successfully',
        () async {
      final client = MockClient();

      var queryParameters = {
        'course_id': "5",
      };
      // print(queryParameters);
      when(client.get(
          Uri.https(
              authority, unencodedPath + "course_list.php", queryParameters),
          headers: <String, String>{
            'authorization': basicAuth
          })).thenAnswer((_) async => http.Response('''{
          "course_id": "5",
          "course_name": "Elementi di Astrofisica",
          "course_cfu": "6",
          "enrollment_year": "2021/2022",
          "study_year": null,
          "teaching_type": "Base",
          "dac": null,
          "department": "Fisica",
          "curriculum": null,
          "ssd": null,
          "delivery_mode": "Convenzionale",
          "language": "Italiano",
          "didactic_period": null,
          "component_type": null
          }''', 200));

      CourseModel course = await getCourseDetailFromWS(client, "5");
      expect(course, isA<CourseModel>());
      expect(course.course_id, "5");
      expect(course.course_name, "Elementi di Astrofisica");
      expect(course.course_cfu, "6");
      expect(course.study_year, "-");
      expect(course.teaching_type, "Base");
      expect(course.department, "Fisica");
    });

    test('error 404', () async {
      final client = MockClient();

      var queryParameters = {
        'course_id': "5",
      };
      // print(queryParameters);
      when(client.get(
          Uri.https(
              authority, unencodedPath + "course_list.php", queryParameters),
          headers: <String, String>{
            'authorization': basicAuth
          })).thenAnswer((_) async => http.Response('Not Found', 404));

      CourseModel course = await getCourseDetailFromWS(client, "5");
      expect(course, null);
    });
  });
}
