import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/tutor_lessonWS.dart';
import 'package:e_tutoring/model/tutorLesson.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'controllerWS.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  // https://www.e-tutoring-app.it/ws/tutor_lesson_list.php?email=paolo.rossi@edu.unito.it
  getTutorLessonFromWSTest();

  // https://www.e-tutoring-app.it/ws/tutor_lesson_today_list.php?email=paolo.rossi@edu.unito.it
  getTutorLessonTodayFromWSTest();
}

getTutorLessonFromWSTest() {
  group('getTutorLessonFromW', () {
    test(
        'return a List of TutorLessonModel if the http call completes successfully',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': "paolo.rossi@edu.unito.it",
      };
      when(client.get(
              Uri.https(authority, unencodedPath + "tutor_lesson_list.php",
                  queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('''[
                  {
                  "tutor_course_id": "51",
                  "note": null,
                  "user_id": "11",
                  "course_id": "36",
                  "private_lesson_id": "66",
                  "tutor_time_slot_id": "82",
                  "day": "2021-07-01 00:00:00",
                  "hour_from": "16:00",
                  "hour_to": "18:00",
                  "reserved": "1",
                  "course_name": "Algoritmi e complessita",
                  "course_cfu": "6",
                  "enrollment_year": "2021/2022",
                  "study_year": "1",
                  "teaching_type": "Caratterizzante",
                  "dac": "INF0097",
                  "department": "Informatica",
                  "curriculum": "Percorso generico",
                  "ssd": "INFORMATICA (INF/01)",
                  "delivery_mode": "Convenzionale",
                  "language": "Italiano",
                  "didactic_period": "Secondo Semestre",
                  "component_type": "Attivit formativa monodisciplinare",
                  "student_id": "1",
                  "student": [
                  {
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
                  "user_id": "1"
                  }
                  ]
                  }
                  ]''', 200));

      List<TutorLessonModel> tutorLessonList =
          await getTutorLessonFromWS(client, email: "paolo.rossi@edu.unito.it");
      expect(tutorLessonList, isA<List<TutorLessonModel>>());
      expect(tutorLessonList.length, 1);
      expect(tutorLessonList[0].tutor_course_id, "51");
      expect(tutorLessonList[0].course_id, "36");
      expect(tutorLessonList[0].course_name, "Algoritmi e complessita");
      expect(tutorLessonList[0].day, "2021-07-01 00:00:00");
      expect(tutorLessonList[0].hour_from, "16:00");
      expect(tutorLessonList[0].hour_to, "18:00");
      expect(tutorLessonList[0].student, isList);
      expect((tutorLessonList[0].student).length, 1);
      expect(tutorLessonList[0].student[0]['firstname'], "Luca");
      expect(tutorLessonList[0].student[0]['lastname'], "Marignati");
      expect(tutorLessonList[0].student[0]['user_id'], "1");
    });

    test(
        'return an empty List of TutorLessonModel if the http call completes with error: 404 ',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': "paolo.rossi@edu.unito.it",
      };
      when(client.get(
              Uri.https(authority, unencodedPath + "tutor_lesson_list.php",
                  queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('Not found', 404));

      List<TutorLessonModel> tutorLessonList =
          await getTutorLessonFromWS(client, email: "paolo.rossi@edu.unito.it");
      expect(tutorLessonList, []);
    });
  });
}

getTutorLessonTodayFromWSTest() {
  group('getTutorLessonTodayFromWS', () {
    test(
        'return a List of TutorLessonModel if the http call completes successfully',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': "paolo.rossi@edu.unito.it",
      };
      when(client.get(
              Uri.https(
                  authority,
                  unencodedPath + "tutor_lesson_today_list.php",
                  queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('''[
                  {
                  "tutor_course_id": "51",
                  "note": null,
                  "user_id": "11",
                  "course_id": "36",
                  "private_lesson_id": "66",
                  "tutor_time_slot_id": "82",
                  "day": "2021-07-01 00:00:00",
                  "hour_from": "16:00",
                  "hour_to": "18:00",
                  "reserved": "1",
                  "course_name": "Algoritmi e complessita",
                  "course_cfu": "6",
                  "enrollment_year": "2021/2022",
                  "study_year": "1",
                  "teaching_type": "Caratterizzante",
                  "dac": "INF0097",
                  "department": "Informatica",
                  "curriculum": "Percorso generico",
                  "ssd": "INFORMATICA (INF/01)",
                  "delivery_mode": "Convenzionale",
                  "language": "Italiano",
                  "didactic_period": "Secondo Semestre",
                  "component_type": "Attivit formativa monodisciplinare",
                  "student_id": "1",
                  "student": [
                  {
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
                  "user_id": "1"
                  }
                  ]
                  }
                  ]''', 200));

      List<TutorLessonModel> tutorLessonList = await getTutorLessonTodayFromWS(
          client,
          email: "paolo.rossi@edu.unito.it");
      expect(tutorLessonList, isA<List<TutorLessonModel>>());
      expect(tutorLessonList.length, 1);
      expect(tutorLessonList[0], isA<TutorLessonModel>());
      expect(tutorLessonList[0].tutor_course_id, "51");
      expect(tutorLessonList[0].course_id, "36");
      expect(tutorLessonList[0].course_name, "Algoritmi e complessita");
      expect(tutorLessonList[0].day, "2021-07-01 00:00:00");
      expect(tutorLessonList[0].hour_from, "16:00");
      expect(tutorLessonList[0].hour_to, "18:00");
      expect(tutorLessonList[0].student, isList);
      expect((tutorLessonList[0].student).length, 1);
      expect(tutorLessonList[0].student[0]['firstname'], "Luca");
      expect(tutorLessonList[0].student[0]['lastname'], "Marignati");
      expect(tutorLessonList[0].student[0]['user_id'], "1");
    });

    test(
        'return an empty List of TutorLessonModel if the http call completes with error: 404 ',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': "paolo.rossi@edu.unito.it",
      };
      when(client.get(
              Uri.https(
                  authority,
                  unencodedPath + "tutor_lesson_today_list.php",
                  queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('Not found', 404));

      List<TutorLessonModel> tutorLessonList = await getTutorLessonTodayFromWS(
          client,
          email: "paolo.rossi@edu.unito.it");
      expect(tutorLessonList, []);
    });
  });
}
