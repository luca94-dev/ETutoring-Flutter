import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/model/degreeModel.dart';
import 'package:http/http.dart' as http;

Future<List<DegreeModel>> getDegreeListFromWS(http.Client client) async {
  List<DegreeModel> degreeList = [];

  try {
    var response = await client.get(
      Uri.https(authority, unencodedPath + "degree_list.php"),
      headers: <String, String>{'authorization': basicAuth},
    );
    if (response.statusCode == 200) {
      var degreeJsonData = json.decode(response.body);
      for (var degreeItem in degreeJsonData) {
        var degree = DegreeModel.fromJson(degreeItem);
        degreeList.add(degree);
      }
    }
    return degreeList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return [];
  }
}
