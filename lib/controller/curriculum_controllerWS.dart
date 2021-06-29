import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/model/curriculumModel.dart';
import 'package:http/http.dart' as http;

Future<List<CurriculumModel>> getCurriculumListFromWS(
    http.Client client, String degreeName, String degreeTypeName) async {
  List<CurriculumModel> curriculumList = [];

  //https://www.e-tutoring-app.it/ws/curriculum_path_by_degree.php?degree_name=informatica&degree_type_note=LaureaTriennale
  var queryParameters = {
    'degree_name': degreeName,
    'degree_type_note': degreeTypeName
  };
  try {
    var response = await client.get(
        Uri.https(authority, unencodedPath + "curriculum_path_by_degree.php",
            queryParameters),
        headers: <String, String>{'authorization': basicAuth});
    if (response.statusCode == 200) {
      var curriculumJsonData = json.decode(response.body);
      for (var curriculumItem in curriculumJsonData) {
        var curriculum = CurriculumModel.fromJson(curriculumItem);
        curriculumList.add(curriculum);
      }
    }
    return curriculumList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return [];
  }
}
