import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/model/reviewModel.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<List<ReviewModel>> getReviewFromWS(
    http.Client client, String userTutorId) async {
  List<ReviewModel> reviewList = [];
  try {
    var queryParameters = {
      'user_tutor_id': userTutorId,
    };
    // print(queryParameters);
    var response = await client.get(
        Uri.https(
            authority, unencodedPath + "reviews_list.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var reviewJsonData = json.decode(response.body);
      for (var item in reviewJsonData) {
        // print(item['id']);
        var reviewItem = ReviewModel.fromJson(item);
        reviewList.add(reviewItem);
      }
    }
    return reviewList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<List<ReviewModel>> getReviewTutorFromWS(http.Client client,
    {String email = ''}) async {
  List<ReviewModel> reviewList = [];
  var queryParameters;
  try {
    if (email == null || email.isEmpty) {
      queryParameters = {
        'email': await UserSecureStorage.getEmail(),
      };
    } else {
      queryParameters = {
        'email': email,
      };
    }
    // print(queryParameters);
    var response = await client.get(
        Uri.https(
            authority, unencodedPath + "reviews_tutor.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var reviewJsonData = json.decode(response.body);
      for (var item in reviewJsonData) {
        var reviewItem = ReviewModel.fromJson(item);
        reviewList.add(reviewItem);
      }
    }
    return reviewList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<List<ReviewModel>> getReviewsUserFromWS(http.Client client,
    {String email = ''}) async {
  List<ReviewModel> reviewList = [];
  var queryParameters;
  try {
    if (email == null || email.isEmpty) {
      queryParameters = {
        'email': await UserSecureStorage.getEmail(),
      };
    } else {
      queryParameters = {
        'email': email,
      };
    }
    // print(queryParameters);
    var response = await client.get(
        Uri.https(
            authority, unencodedPath + "reviews_user.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var reviewJsonData = json.decode(response.body);
      for (var item in reviewJsonData) {
        var reviewItem = ReviewModel.fromJson(item);
        reviewList.add(reviewItem);
      }
    }
    return reviewList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}
