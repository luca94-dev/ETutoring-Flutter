import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/controller/degree_controller.dart';
import 'package:e_tutoring/model/degreeModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'controllerWS.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  getDegreeListFromWSTest();
}

getDegreeListFromWSTest() {
  group('getDegreeListFromWSTest', () {
    test('return a List of DegreeModel if the http call completes successfully',
        () async {
      final client = MockClient();

      when(client.get(Uri.https(authority, unencodedPath + "degree_list.php"),
              headers: <String, String>{'authorization': basicAuth}))
          .thenAnswer((_) async =>
              http.Response('''[{"degree_id": "5","degree_name": "Fisica",
		        "degree_cfu": "180","degree_description": "",
		        "degree_type_id": "1",
		        "degree_location": "Torino",
	        	"degree_athenaeum": "Unito",
		        "degree_type_name": "LT",
		        "degree_type_note": "Laurea Triennale"
	        }]''', 200));

      List<DegreeModel> degreeList = await getDegreeListFromWS(client);
      expect(degreeList, isA<List<DegreeModel>>());
    });
  });
}
