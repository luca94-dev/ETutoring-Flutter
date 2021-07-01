import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/review_controller.dart';
import 'package:e_tutoring/model/reviewModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'controllerWS.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  // https://www.e-tutoring-app.it/ws/reviews_list.php
  getReviewFromWSTest();

  // https://www.e-tutoring-app.it/ws/reviews_tutor.php?email=paolo.rossi@edu.unito.it
  getReviewTutorFromWSTest();

  // https://www.e-tutoring-app.it/ws/reviews_user.php?email=davide.decenzo@edu.unito.it
  getReviewsUserFromWSTest();
}

getReviewFromWSTest() {
  group('getReviewFromWS', () {
    test('return a List of ReviewModel if the http call completes successfully',
        () async {
      final client = MockClient();
      var queryParameters = {
        'user_tutor_id': "1",
      };
      when(client.get(
          Uri.https(
              authority, unencodedPath + "reviews_list.php", queryParameters),
          headers: <String, String>{
            'authorization': basicAuth
          })).thenAnswer((_) async => http.Response('''
          [{
            "review_id": "3",
            "user_tutor_id": "11",
            "user_id": "3",
            "review_star": "5",
            "review_comment": "Aiuto indispensabile per passare l'esame di Agenti Intelligenti!",
            "id": "3",
            "username": "davide.decenzo",
            "password": "098f6bcd4621d373cade4e832627b4f6",
            "email": "davide.decenzo@edu.unito.it",
            "created_at": "2021-05-07 09:15:35",
            "updated_at": "2021-05-07 09:15:35",
            "user_attribute_id": "3",
            "firstname": "Davide",
            "lastname": "De Cenzo",
            "description": null,
            "img": null,
            "badge_number": "785552",
            "cf": null,
            "birth_date": null,
            "birth_city": null,
            "residence_city": null,
            "address": null,
            "nationality": "Italiana",
            "gender": null,
            "phone_number": null,
            "degree_id": "2",
            "degree_path_id": "1",
            "role_id": "1"
            }]''', 200));

      List<ReviewModel> reviewList = await getReviewFromWS(client, '1');
      expect(reviewList, isA<List<ReviewModel>>());
      expect(reviewList.length, 1);
      expect(reviewList[0].review_id, "3");
      expect(reviewList[0].user_tutor_id, "11");
      expect(reviewList[0].review_star, "5");
      expect(reviewList[0].review_comment,
          "Aiuto indispensabile per passare l'esame di Agenti Intelligenti!");
      expect(reviewList[0].username, "davide.decenzo");
      expect(reviewList[0].firstname, "Davide");
      expect(reviewList[0].lastname, "De Cenzo");
    });

    test(
        'return an empty List of ReviewModel if the http call completes with error 404',
        () async {
      final client = MockClient();
      var queryParameters = {
        'user_tutor_id': "1",
      };
      when(client.get(
          Uri.https(
              authority, unencodedPath + "reviews_list.php", queryParameters),
          headers: <String, String>{
            'authorization': basicAuth
          })).thenAnswer((_) async => http.Response('Not found', 404));

      List<ReviewModel> reviewList = await getReviewFromWS(client, '1');
      expect(reviewList, isA<List<ReviewModel>>());
      expect(reviewList.length, 0);
      expect(reviewList, []);
    });
  });
}

getReviewTutorFromWSTest() {
  group('getReviewTutorFromWS', () {
    test(
        'return a List of ReviewModel of Tutor if the http call completes successfully',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': "davide.decenzo@edu.unito.it",
      };
      when(client.get(
          Uri.https(
              authority, unencodedPath + "reviews_tutor.php", queryParameters),
          headers: <String, String>{
            'authorization': basicAuth
          })).thenAnswer((_) async => http.Response('''[{
                "review_id": "1",
                "user_tutor_id": "11",
                "user_id": "1",
                "review_star": "5",
                "review_comment": "Tutor eccellente!",
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
                "role_id": "1"
                },
                {
                "review_id": "2",
                "user_tutor_id": "11",
                "user_id": "2",
                "review_star": "5",
                "review_comment": "Ottime spiegazioni e esito dell'esame  stato 30L. Grazie Mille.",
                "id": "2",
                "username": "simone.bortolotti",
                "password": "098f6bcd4621d373cade4e832627b4f6",
                "email": "simone.bortolotti@edu.unito.it",
                "created_at": "2021-05-07 09:15:35",
                "updated_at": "2021-05-07 09:15:35",
                "user_attribute_id": "2",
                "firstname": "Simone",
                "lastname": "Bortolotti",
                "description": "-",
                "img": null,
                "badge_number": "802598",
                "cf": null,
                "birth_date": "",
                "birth_city": "Torino",
                "residence_city": "-",
                "address": null,
                "nationality": "Italiana",
                "gender": null,
                "phone_number": "3347590258",
                "degree_id": "2",
                "degree_path_id": "1",
                "role_id": "1"
                }]''', 200));

      List<ReviewModel> reviewList = await getReviewTutorFromWS(client,
          email: 'davide.decenzo@edu.unito.it');
      expect(reviewList, isA<List<ReviewModel>>());
      expect(reviewList.length, 2);
      expect(reviewList[0].toString(),
          "review_id = 1\nreview_comment = Tutor eccellente!");
      expect(reviewList[1].toString(),
          "review_id = 2\nreview_comment = Ottime spiegazioni e esito dell'esame  stato 30L. Grazie Mille.");
      expect(reviewList[0], isA<ReviewModel>());
      expect(reviewList[1], isA<ReviewModel>());
      expect(reviewList[0].review_id, "1");
      expect(reviewList[1].review_id, "2");
      expect(reviewList[0].review_star, "5");
      expect(reviewList[1].review_star, "5");
      expect(reviewList[0].review_comment, "Tutor eccellente!");
      expect(reviewList[1].review_comment,
          "Ottime spiegazioni e esito dell'esame  stato 30L. Grazie Mille.");
      expect(reviewList[0].username, "luca.marignati");
      expect(reviewList[1].username, "simone.bortolotti");
      expect(reviewList[0].firstname, "Luca");
      expect(reviewList[1].firstname, "Simone");
      expect(reviewList[0].lastname, "Marignati");
      expect(reviewList[1].lastname, "Bortolotti");
    });

    test(
        'return a List of ReviewModel of Tutor if the http call completes successfully',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': "davide.decenzo@edu.unito.it",
      };
      when(client.get(
          Uri.https(
              authority, unencodedPath + "reviews_tutor.php", queryParameters),
          headers: <String, String>{
            'authorization': basicAuth
          })).thenAnswer((_) async => http.Response('Not found', 404));

      List<ReviewModel> reviewList = await getReviewTutorFromWS(client,
          email: 'davide.decenzo@edu.unito.it');
      expect(reviewList, isA<List<ReviewModel>>());
      expect(reviewList.length, 0);
      expect(reviewList, []);
    });
  });
}

getReviewsUserFromWSTest() {
  group('getReviewsUserFromWS', () {
    test(
        'return a List of ReviewModel of Users if the http call completes successfully',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': "luca.marignati@edu.unito.it",
      };
      when(client.get(
          Uri.https(
              authority, unencodedPath + "reviews_user.php", queryParameters),
          headers: <String, String>{
            'authorization': basicAuth
          })).thenAnswer((_) async => http.Response('''
          [{
          "review_id": "3",
          "user_tutor_id": "11",
          "user_id": "11",
          "review_star": "5",
          "review_comment": "Aiuto indispensabile per passare l'esame di Agenti Intelligenti!",
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
          "role_id": "2"
          }
          ]''', 200));

      List<ReviewModel> reviewList = await getReviewsUserFromWS(client,
          email: 'luca.marignati@edu.unito.it');
      expect(reviewList, isA<List<ReviewModel>>());
      expect(reviewList.length, 1);
      expect(reviewList[0], isA<ReviewModel>());
      expect(reviewList[0].toString(),
          "review_id = 3\nreview_comment = Aiuto indispensabile per passare l'esame di Agenti Intelligenti!");
      expect(reviewList[0].review_id, "3");
      expect(reviewList[0].review_star, "5");
      expect(reviewList[0].review_comment,
          "Aiuto indispensabile per passare l'esame di Agenti Intelligenti!");
      expect(reviewList[0].firstname, "Paolo");
      expect(reviewList[0].lastname, "Rossi");
    });

    test(
        'return a List of ReviewModel of Users if the http call completes successfully',
        () async {
      final client = MockClient();
      var queryParameters = {
        'email': "luca.marignati@edu.unito.it",
      };
      when(client.get(
          Uri.https(
              authority, unencodedPath + "reviews_user.php", queryParameters),
          headers: <String, String>{
            'authorization': basicAuth
          })).thenAnswer((_) async => http.Response('>Not found', 404));

      List<ReviewModel> reviewList = await getReviewsUserFromWS(client,
          email: 'luca.marignati@edu.unito.it');
      expect(reviewList, isA<List<ReviewModel>>());
      expect(reviewList.length, 0);
      expect(reviewList, []);
    });
  });
}
