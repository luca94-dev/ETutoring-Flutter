import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/tutor_controllerWS.dart';
import 'package:e_tutoring/model/tutorModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'controllerWS.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  // https://www.e-tutoring-app.it/ws/tutor_list.php
  getTutorSearchFromWSTest();

  // https://www.e-tutoring-app.it/ws/tutor_list.php?email=paolo.rossi@edu.unito.it
  getTutorDetailFromWSTest();
}

getTutorSearchFromWSTest() {
  group('getTutorSearchFromWS', () {
    test('return a List of TutorModel if the http call completes successfully',
        () async {
      final client = MockClient();

      when(client.get(Uri.https(authority, unencodedPath + "tutor_list.php"),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('''[{"id": "11",
            "username": "paolo.rossi",
            "password": "098f6bcd4621d373cade4e832627b4f6",
            "email": "paolo.rossi@edu.unito.it",
            "created_at": "2021-06-10 08:51:39",
            "updated_at": "2021-06-10 08:51:39",
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
            "user_id": "11",
            "role_name": "Tutor",
            "role_description": "Tutor",
            "time_slot": [],
            "courses": [
            {
            "tutor_course_id": "51",
            "note": null,
            "user_id": "11",
            "course_id": "36",
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
            "component_type": "Attivit formativa monodisciplinare"
            },
            {
            "tutor_course_id": "53",
            "note": null,
            "user_id": "11",
            "course_id": "38",
            "course_name": "Analisi e Trattamento dei Segnali Digitali",
            "course_cfu": "6",
            "enrollment_year": "2021/2022",
            "study_year": "1",
            "teaching_type": "Caratterizzante",
            "dac": "INF0096",
            "department": "Informatica",
            "curriculum": "Realta virtuale e Multimedialita",
            "ssd": "INFORMATICA (INF/01)",
            "delivery_mode": "Convenzionale",
            "language": "Italiano",
            "didactic_period": "Primo Semestre",
            "component_type": "Attivit formativa monodisciplinare"
            },
            {
            "tutor_course_id": "54",
            "note": null,
            "user_id": "11",
            "course_id": "15",
            "course_name": "Algoritmi e Strutture Dati",
            "course_cfu": "9",
            "enrollment_year": "2021/2022",
            "study_year": null,
            "teaching_type": "Caratterizzante",
            "dac": "MFN0597",
            "department": "Informatica",
            "curriculum": "Percorso generico",
            "ssd": "INFORMATICA (INF/01)",
            "delivery_mode": "Convenzionale",
            "language": "Italiano",
            "didactic_period": "Secondo Semestre",
            "component_type": "Attivit formativa monodisciplinare"
            },
            {
            "tutor_course_id": "77",
            "note": null,
            "user_id": "11",
            "course_id": "42",
            "course_name": "Bioinformatica",
            "course_cfu": "6",
            "enrollment_year": "2021/2022",
            "study_year": "1",
            "teaching_type": "Caratterizzante",
            "dac": "MFN0951",
            "department": "Informatica",
            "curriculum": "Percorso generico",
            "ssd": "INFORMATICA (INF/01)",
            "delivery_mode": "Convenzionale",
            "language": "Italiano",
            "didactic_period": "Primo Semestre",
            "component_type": "Attivit formativa monodisciplinare"
            },
            {
            "tutor_course_id": "78",
            "note": null,
            "user_id": "11",
            "course_id": "22",
            "course_name": "Interazione Uomo Macchina e Tecnologie Web",
            "course_cfu": "12",
            "enrollment_year": "2021/2022",
            "study_year": null,
            "teaching_type": "Caratterizzante",
            "dac": "MFN0608",
            "department": "Informatica",
            "curriculum": "Informazione e conoscenza",
            "ssd": "INFORMATICA (INF/01)",
            "delivery_mode": "Convenzionale",
            "language": "Italiano",
            "didactic_period": "Primo Semestre",
            "component_type": "Attivit formativa monodisciplinare"
            }
            ],
            "reviews": [
            {
            "review_id": "1",
            "user_tutor_id": "11",
            "user_id": "1",
            "review_star": "5",
            "review_comment": "Tutor eccellente!"
            },
            {
            "review_id": "2",
            "user_tutor_id": "11",
            "user_id": "2",
            "review_star": "5",
            "review_comment": "Ottime spiegazioni e esito dell'esame  stato 30L. Grazie Mille."
            },
            {
            "review_id": "3",
            "user_tutor_id": "11",
            "user_id": "3",
            "review_star": "5",
            "review_comment": "Aiuto indispensabile per passare l'esame di Agenti Intelligenti!"
            },
            {
            "review_id": "6",
            "user_tutor_id": "11",
            "user_id": "2",
            "review_star": "5",
            "review_comment": "Ottimo insegnante! Preparato! Lo consiglio!"
            }
            ],
            "avg_reviews": 5}]''', 200));

      List<TutorModel> tutorList = await getTutorSearchFromWS(client);
      expect(tutorList, isA<List<TutorModel>>());
      expect(tutorList.length, 1);
      expect(tutorList[0], isA<TutorModel>());
      expect(tutorList[0].id, "11");
      expect(tutorList[0].username, "paolo.rossi");
      expect(tutorList[0].firstname, "Paolo");
      expect(tutorList[0].lastname, "Rossi");
      expect(tutorList[0].birth_city, "Torino");
      expect(tutorList[0].residence_city, "Torino");
      expect(tutorList[0].nationality, "Italiana");
      expect(tutorList[0].role_name, "Tutor");
      expect(tutorList[0].time_slot, isList);
      expect(tutorList[0].time_slot, []);
      expect((tutorList[0].time_slot).length, 0);
      expect(tutorList[0].courses, isList);
      expect((tutorList[0].courses).length, 5);
      expect(tutorList[0].courses[0]['course_name'], "Algoritmi e complessita");
      expect(tutorList[0].courses[1]['course_name'],
          "Analisi e Trattamento dei Segnali Digitali");
      expect(tutorList[0].reviews, isList);
      expect((tutorList[0].reviews).length, 4);
      expect(tutorList[0].reviews[0]['review_star'], "5");
      expect(tutorList[0].reviews[0]['review_comment'], "Tutor eccellente!");
      expect(tutorList[0].reviews[1]['review_star'], "5");
      expect(tutorList[0].reviews[1]['review_comment'],
          "Ottime spiegazioni e esito dell'esame  stato 30L. Grazie Mille.");
      expect(tutorList[0].avg_reviews, 5);
    });

    test(
        'return an empty List of TutorModel if the http call completes with error: 404 ',
        () async {
      final client = MockClient();

      when(client.get(Uri.https(authority, unencodedPath + "tutor_list.php"),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('Not found', 404));

      List<TutorModel> tutorList = await getTutorSearchFromWS(client);
      expect(tutorList, []);
    });
  });
}

getTutorDetailFromWSTest() {
  group('getTutorDetailFromWS', () {
    test('return a TutorModel if the http call completes successfully',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': "paolo.rossi@edu.unito.it",
      };
      when(client.get(
              Uri.https(
                  authority, unencodedPath + "tutor_list.php", queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('''{
"id": "11",
"username": "paolo.rossi",
"password": "098f6bcd4621d373cade4e832627b4f6",
"email": "paolo.rossi@edu.unito.it",
"created_at": "2021-06-10 08:51:39",
"updated_at": "2021-06-10 08:51:39",
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
"user_id": "11",
"role_name": "Tutor",
"role_description": "Tutor",
"time_slot": [],
"courses": [
{
"tutor_course_id": "51",
"note": null,
"user_id": "11",
"course_id": "36",
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
"component_type": "Attivit formativa monodisciplinare"
},
{
"tutor_course_id": "53",
"note": null,
"user_id": "11",
"course_id": "38",
"course_name": "Analisi e Trattamento dei Segnali Digitali",
"course_cfu": "6",
"enrollment_year": "2021/2022",
"study_year": "1",
"teaching_type": "Caratterizzante",
"dac": "INF0096",
"department": "Informatica",
"curriculum": "Realta virtuale e Multimedialita",
"ssd": "INFORMATICA (INF/01)",
"delivery_mode": "Convenzionale",
"language": "Italiano",
"didactic_period": "Primo Semestre",
"component_type": "Attivit formativa monodisciplinare"
},
{
"tutor_course_id": "54",
"note": null,
"user_id": "11",
"course_id": "15",
"course_name": "Algoritmi e Strutture Dati",
"course_cfu": "9",
"enrollment_year": "2021/2022",
"study_year": null,
"teaching_type": "Caratterizzante",
"dac": "MFN0597",
"department": "Informatica",
"curriculum": "Percorso generico",
"ssd": "INFORMATICA (INF/01)",
"delivery_mode": "Convenzionale",
"language": "Italiano",
"didactic_period": "Secondo Semestre",
"component_type": "Attivit formativa monodisciplinare"
},
{
"tutor_course_id": "77",
"note": null,
"user_id": "11",
"course_id": "42",
"course_name": "Bioinformatica",
"course_cfu": "6",
"enrollment_year": "2021/2022",
"study_year": "1",
"teaching_type": "Caratterizzante",
"dac": "MFN0951",
"department": "Informatica",
"curriculum": "Percorso generico",
"ssd": "INFORMATICA (INF/01)",
"delivery_mode": "Convenzionale",
"language": "Italiano",
"didactic_period": "Primo Semestre",
"component_type": "Attivit formativa monodisciplinare"
},
{
"tutor_course_id": "78",
"note": null,
"user_id": "11",
"course_id": "22",
"course_name": "Interazione Uomo Macchina e Tecnologie Web",
"course_cfu": "12",
"enrollment_year": "2021/2022",
"study_year": null,
"teaching_type": "Caratterizzante",
"dac": "MFN0608",
"department": "Informatica",
"curriculum": "Informazione e conoscenza",
"ssd": "INFORMATICA (INF/01)",
"delivery_mode": "Convenzionale",
"language": "Italiano",
"didactic_period": "Primo Semestre",
"component_type": "Attivit formativa monodisciplinare"
}
],
"reviews": [
{
"review_id": "1",
"user_tutor_id": "11",
"user_id": "1",
"review_star": "5",
"review_comment": "Tutor eccellente!"
},
{
"review_id": "2",
"user_tutor_id": "11",
"user_id": "2",
"review_star": "5",
"review_comment": "Ottime spiegazioni e esito dell'esame  stato 30L. Grazie Mille."
},
{
"review_id": "3",
"user_tutor_id": "11",
"user_id": "3",
"review_star": "5",
"review_comment": "Aiuto indispensabile per passare l'esame di Agenti Intelligenti!"
},
{
"review_id": "6",
"user_tutor_id": "11",
"user_id": "2",
"review_star": "5",
"review_comment": "Ottimo insegnante! Preparato! Lo consiglio!"
}
],
"avg_reviews": 5
}''', 200));

      TutorModel tutor =
          await getTutorDetailFromWS(client, email: "paolo.rossi@edu.unito.it");
      expect(tutor, isA<TutorModel>());
      expect(tutor.id, "11");
      expect(tutor.username, "paolo.rossi");
      expect(tutor.firstname, "Paolo");
      expect(tutor.lastname, "Rossi");
      expect(tutor.birth_city, "Torino");
      expect(tutor.residence_city, "Torino");
      expect(tutor.nationality, "Italiana");
      expect(tutor.role_name, "Tutor");
      expect(tutor.time_slot, isList);
      expect(tutor.time_slot, []);
      expect((tutor.time_slot).length, 0);
      expect(tutor.courses, isList);
      expect((tutor.courses).length, 5);
      expect(tutor.courses[0]['course_name'], "Algoritmi e complessita");
      expect(tutor.courses[1]['course_name'],
          "Analisi e Trattamento dei Segnali Digitali");
      expect(tutor.reviews, isList);
      expect((tutor.reviews).length, 4);
      expect(tutor.reviews[0]['review_star'], "5");
      expect(tutor.reviews[0]['review_comment'], "Tutor eccellente!");
      expect(tutor.reviews[1]['review_star'], "5");
      expect(tutor.reviews[1]['review_comment'],
          "Ottime spiegazioni e esito dell'esame  stato 30L. Grazie Mille.");
      expect(tutor.avg_reviews, 5);
    });

    test('return null object if the http call completes with error: 404',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': "paolo.rossi@edu.unito.it",
      };
      when(client.get(
              Uri.https(
                  authority, unencodedPath + "tutor_list.php", queryParameters),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async => http.Response('Not found', 404));

      TutorModel tutor =
          await getTutorDetailFromWS(client, email: "paolo.rossi@edu.unito.it");
      expect(tutor, null);
    });
  });
}
