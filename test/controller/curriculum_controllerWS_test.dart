import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/curriculum_controllerWS.dart';
import 'package:e_tutoring/model/curriculumModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'controllerWS.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  getCurriculumListFromWSTest();
}

getCurriculumListFromWSTest() {
  group('getCurriculumListFromWS', () {
    test(
        'return a List of CurriculumModel if the http call completes successfully',
        () async {
      final client = MockClient();
      var queryParameters = {
        'degree_name': 'informatica',
        'degree_type_note': 'Laurea Magistrale'
      };
      when(client.get(
          Uri.https(authority, unencodedPath + "curriculum_path_by_degree.php",
              queryParameters),
          headers: <String, String>{
            'authorization': basicAuth
          })).thenAnswer((_) async => http.Response(
          '[{"degree_path_name": "Immagini, Visione e Realt Virtuale"}]', 200));

      List<CurriculumModel> curriculumList = await getCurriculumListFromWS(
          client, 'informatica', 'Laurea Magistrale');
      expect(curriculumList, isA<List<CurriculumModel>>());
    });
  });
}
