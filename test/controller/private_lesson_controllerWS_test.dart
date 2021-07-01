import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/private_lesson_controllerWS.dart';
import 'package:e_tutoring/model/privatelessonModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'controllerWS.mocks.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
void main() {
  /**
   * getPrivateLessonFromWS
   * https://www.e-tutoring-app.it/ws/private_lesson_list.php?email=luca.marignati@edu.unito.it
   */
  getPrivateLessonFromWSTest();

  /**
   * getPrivateLessonTodayFromWS
   * https://www.e-tutoring-app.it/ws/private_lesson_today_list.php?email=luca.marignati@edu.unito.it
   */
  getPrivateLessonTodayFromWSTest();
}

getPrivateLessonFromWSTest() {
  group('getPrivateLessonFromWS', () {
    test(
        'return a List of PrivatelessonModel if the http call completes successfully',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': "luca.marignati@edu.unito.it",
      };
      when(client.get(
              Uri.https(authority, unencodedPath + "private_lesson_list.php",
                  queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('''[{
              "private_lesson_id": "66",
              "user_id": "11",
              "tutor_course_id": "51",
              "tutor_time_slot_id": "82",
              "note": null,
              "id": "1",
              "username": "luca.marignati",
              "password": "098f6bcd4621d373cade4e832627b4f6",
              "email": "luca.marignati@edu.unito.it",
              "created_at": "2021-05-07 09:15:35",
              "updated_at": "2021-05-07 09:15:35",
              "course_id": "36",
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
              "tutor": [
              {
              "user_attribute_id": "13",
              "firstname": "Paolo",
              "lastname": "Rossi",
              "description": "Sono uno studente del Politecnico di Torino in Ingegneria meccanica. Fornisco ripetizioni di matematica, fisica, geometria e disegno tecnico.",
              "img": null,
              "badge_number": null,
              "cf": null,
              "birth_date": null,
              "birth_city": "Torino",
              "residence_city": "Torino",
              "address": "Via Botticelli",
              "nationality": "Italiana",
              "gender": "M",
              "phone_number": "3347811074",
              "degree_id": null,
              "degree_path_id": null,
              "role_id": "2",
              "user_id": "11"
              }]}]''', 200));

      List<PrivatelessonModel> privatelessonList = await getPrivateLessonFromWS(
          client,
          email: "luca.marignati@edu.unito.it");
      expect(privatelessonList, isA<List<PrivatelessonModel>>());
      expect(privatelessonList.length, 1);
      expect(privatelessonList[0], isA<PrivatelessonModel>());
      expect(privatelessonList[0].private_lesson_id, "66");
      expect(privatelessonList[0].user_id, "11");
      expect(privatelessonList[0].tutor_course_id, "51");
      expect(privatelessonList[0].tutor_time_slot_id, "82");
      expect(privatelessonList[0].username, "luca.marignati");
      expect(privatelessonList[0].email, "luca.marignati@edu.unito.it");
      expect(privatelessonList[0].course_id, "36");
      expect(privatelessonList[0].day, "2021-07-01 00:00:00");
      expect(privatelessonList[0].hour_from, "16:00");
      expect(privatelessonList[0].hour_to, "18:00");
      expect(privatelessonList[0].reserved, "1");
      expect(privatelessonList[0].course_name, "Algoritmi e complessita");
      expect(privatelessonList[0].course_cfu, "6");
      expect(privatelessonList[0].tutor, isA<List>());
      expect((privatelessonList[0].tutor).length, 1);
      expect(privatelessonList[0].tutor[0]['firstname'], "Paolo");
      expect(privatelessonList[0].tutor[0]['lastname'], "Rossi");
      expect(privatelessonList[0].tutor[0]['description'],
          "Sono uno studente del Politecnico di Torino in Ingegneria meccanica. Fornisco ripetizioni di matematica, fisica, geometria e disegno tecnico.");
    });

    test(
        'return an empty List of PrivatelessonModel if the http call completes with error 404',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': "luca.marignati@edu.unito.it",
      };
      when(client.get(
              Uri.https(authority, unencodedPath + "private_lesson_list.php",
                  queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('Not found', 404));

      List<PrivatelessonModel> privatelessonList = await getPrivateLessonFromWS(
          client,
          email: "luca.marignati@edu.unito.it");
      expect(privatelessonList, isA<List<PrivatelessonModel>>());
      expect(privatelessonList.length, 0);
      expect(privatelessonList, []);
    });
  });
}

getPrivateLessonTodayFromWSTest() {
  group('getPrivateLessonTodayFromWS', () {
    test(
        'return a List of PrivatelessonModel if the http call completes successfully',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': "luca.marignati@edu.unito.it",
      };
      when(client.get(
              Uri.https(
                  authority,
                  unencodedPath + "private_lesson_today_list.php",
                  queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('''[{
              "private_lesson_id": "66",
              "user_id": "11",
              "tutor_course_id": "51",
              "tutor_time_slot_id": "82",
              "note": null,
              "id": "1",
              "username": "luca.marignati",
              "password": "098f6bcd4621d373cade4e832627b4f6",
              "email": "luca.marignati@edu.unito.it",
              "created_at": "2021-05-07 09:15:35",
              "updated_at": "2021-05-07 09:15:35",
              "course_id": "36",
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
              "tutor": [
              {
              "user_attribute_id": "13",
              "firstname": "Paolo",
              "lastname": "Rossi",
              "description": "Sono uno studente del Politecnico di Torino in Ingegneria meccanica. Fornisco ripetizioni di matematica, fisica, geometria e disegno tecnico.",
              "img": null,
              "badge_number": null,
              "cf": null,
              "birth_date": null,
              "birth_city": "Torino",
              "residence_city": "Torino",
              "address": "Via Botticelli",
              "nationality": "Italiana",
              "gender": "M",
              "phone_number": "3347811074",
              "degree_id": null,
              "degree_path_id": null,
              "role_id": "2",
              "user_id": "11"
              }]}]''', 200));

      List<PrivatelessonModel> privatelessonList =
          await getPrivateLessonTodayFromWS(client,
              email: "luca.marignati@edu.unito.it");
      expect(privatelessonList, isA<List<PrivatelessonModel>>());
      expect(privatelessonList.length, 1);
      expect(privatelessonList[0], isA<PrivatelessonModel>());
      expect(privatelessonList[0].private_lesson_id, "66");
      expect(privatelessonList[0].user_id, "11");
      expect(privatelessonList[0].tutor_course_id, "51");
      expect(privatelessonList[0].tutor_time_slot_id, "82");
      expect(privatelessonList[0].username, "luca.marignati");
      expect(privatelessonList[0].email, "luca.marignati@edu.unito.it");
      expect(privatelessonList[0].course_id, "36");
      expect(privatelessonList[0].day, "2021-07-01 00:00:00");
      expect(privatelessonList[0].hour_from, "16:00");
      expect(privatelessonList[0].hour_to, "18:00");
      expect(privatelessonList[0].reserved, "1");
      expect(privatelessonList[0].course_name, "Algoritmi e complessita");
      expect(privatelessonList[0].course_cfu, "6");
      expect(privatelessonList[0].tutor, isA<List>());
      expect((privatelessonList[0].tutor).length, 1);
      expect(privatelessonList[0].tutor[0]['firstname'], "Paolo");
      expect(privatelessonList[0].tutor[0]['lastname'], "Rossi");
      expect(privatelessonList[0].tutor[0]['description'],
          "Sono uno studente del Politecnico di Torino in Ingegneria meccanica. Fornisco ripetizioni di matematica, fisica, geometria e disegno tecnico.");
    });

    test(
        'return an empty List of PrivatelessonModel if the http call completes with error 404',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': "luca.marignati@edu.unito.it",
      };
      when(client.get(
              Uri.https(
                  authority,
                  unencodedPath + "private_lesson_today_list.php",
                  queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('Not found', 404));

      List<PrivatelessonModel> privatelessonList =
          await getPrivateLessonTodayFromWS(client,
              email: "luca.marignati@edu.unito.it");
      expect(privatelessonList, isA<List<PrivatelessonModel>>());
      expect(privatelessonList.length, 0);
      expect(privatelessonList, []);
    });
  });
}
