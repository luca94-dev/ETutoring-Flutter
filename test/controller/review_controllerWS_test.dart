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
  getReviewFromWSTest();

  getReviewTutorFromWSTest();

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
          [{"review_id": "1",
            "user_tutor_id": "1",
            "user_id": "1",
            "review_star": "5",
            "review_comment": "Lezione Ottima",
            "email": "davide.decenzo@edu.unito.it",
            "username": "JohnHundred",
            "firstname": "Davide",
            "lastname": "De Cenzo"
          
          }]
          ''', 200));

      List<ReviewModel> reviewList = await getReviewFromWS(client, '1');
      expect(reviewList, isA<List<ReviewModel>>());
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
          })).thenAnswer((_) async => http.Response('''
          [{"review_id": "1",
            "user_tutor_id": "1",
            "user_id": "1",
            "review_star": "5",
            "review_comment": "Lezione Ottima",
            "email": "davide.decenzo@edu.unito.it",
            "username": "JohnHundred",
            "firstname": "Davide",
            "lastname": "De Cenzo"
          
          }]
          ''', 200));

      List<ReviewModel> reviewList = await getReviewTutorFromWS(client,
          email: 'davide.decenzo@edu.unito.it');
      expect(reviewList, isA<List<ReviewModel>>());
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
          [{"review_id": "1",
            "user_tutor_id": "3",
            "user_id": "5",
            "review_star": "1",
            "review_comment": "Non ho capito molto dalla lezione",
            "email": "luca.marignati@edu.unito.it",
            "username": "Luca4All",
            "firstname": "Luca",
            "lastname": "Marignati"
          
          }]
          ''', 200));

      List<ReviewModel> reviewList = await getReviewsUserFromWS(client,
          email: 'luca.marignati@edu.unito.it');
      expect(reviewList, isA<List<ReviewModel>>());
    });
  });
}
