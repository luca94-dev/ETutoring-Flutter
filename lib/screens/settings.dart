import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/screens/login.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:e_tutoring/widgets/drawer.dart';
import 'package:e_tutoring/widgets/language_picker_widget.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String email;

  // For CircularProgressIndicator.
  bool visible = false;

  @override
  void initState() {
    super.initState();
    print("init settings");
  }

  @override
  void dispose() {
    print("dispose settings");
    super.dispose();
  }

  Future init() async {
    final email = await UserSecureStorage.getEmail() ?? '';
    this.email = email;
  }

  Future userDelete() async {
    setState(() {
      // Showing CircularProgressIndicator.
      visible = true;
    });

    try {
      // Getting value from Controller
      String email = await UserSecureStorage.getEmail();
      // Store all data with Param Name: json format
      var data = {
        'email': email,
      };
      // print(json.encode(data));
      // Starting Web API Call.
      // http method: POST
      var response = await http
          .post(Uri.https(authority, unencodedPath + 'user_delete.php'),
              headers: <String, String>{'authorization': basicAuth},
              body: json.encode(data))
          .timeout(const Duration(seconds: 8));
      // print(response.body);
      var message = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (message == 'User deleted successfully') {
          // Delete email from secure storage
          UserSecureStorage.delete('email');
          // Delete password from secure storage
          UserSecureStorage.delete('password');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login()));
        } else {}
      } else {}
      setState(() {
        // Showing CircularProgressIndicator.
        visible = false;
      });
    } on Exception catch ($e) {
      print('error caught: ' + $e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error. Verify Your Connection.'),
        backgroundColor: Colors.redAccent,
      ));
      setState(() {
        visible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context).settings),
          backgroundColor: Color.fromRGBO(213, 21, 36, 1)),
      // Nav Bar (title: 'Profilo', bgColor: Color.fromRGBO(213, 21, 36, 1)),
      drawer: ArgonDrawer("settings"),
      body: Stack(children: <Widget>[
        SafeArea(
            child: ListView(children: [
          Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DataTable(
                        dataRowHeight: 50,
                        dataRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        headingRowHeight: 0,
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text(
                              '',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              '',
                            ),
                          ),
                        ],
                        rows: <DataRow>[
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text(
                                AppLocalizations.of(context).language,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )),
                              DataCell(LanguagePickerWidget()),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text(
                                  AppLocalizations.of(context).cancel_account,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))),
                              DataCell(
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    //minimumSize: Size.fromHeight(52),
                                    primary: ArgonColors.redUnito,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => new AlertDialog(
                                              // backgroundColor: Colors.grey,
                                              title: new Text('Are you sure?',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20)),
                                              content: new Text(
                                                  'Do you want to delete your account?',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: new Text(
                                                    'No',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                    userDelete();
                                                  },
                                                  child: new Text('Yes',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20)),
                                                ),
                                              ],
                                            ));
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 16.0,
                                          right: 16.0,
                                          top: 12,
                                          bottom: 12),
                                      child: Text(
                                          AppLocalizations.of(context).cancel,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0))),
                                ),
                              ),
                            ],
                          )
                        ]),
                    const SizedBox(height: 20),
                    Visibility(
                      visible: visible,
                      child: Center(
                          child: Container(
                              margin: EdgeInsets.only(bottom: 30),
                              child: CircularProgressIndicator(
                                backgroundColor: ArgonColors.redUnito,
                              ))),
                    ),
                  ]))
        ]))
      ]),
    );
  }
}
