import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/controller/tutor_controllerWS.dart';
import 'package:e_tutoring/l10n/l10n.dart';
import 'package:e_tutoring/model/tutorTimeslotModel.dart';
import 'package:e_tutoring/model/tutorModel.dart';
import 'package:e_tutoring/provider/locale_provider.dart';
import 'package:e_tutoring/screens/my-tutor-timeslot-add.dart';
import 'package:e_tutoring/utils/routeGenerator.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:e_tutoring/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyTutorTimeslot extends StatefulWidget {
  @override
  MyTutorTimeslotState createState() => new MyTutorTimeslotState();
}

class MyTutorTimeslotState extends State<MyTutorTimeslot> {
  TutorModel tutor;
  List<TutorTimeslotModel> timeslotListSelected = [];
  List<TutorTimeslotModel> timeslotList = [];

  // CONTROLLER
  Future deleteTimeslots(List<TutorTimeslotModel> courseListSelected) async {
    try {
      int totalCoursesSelected = courseListSelected.length;
      String errorMsg = "";
      String email = await UserSecureStorage.getEmail();
      if (courseListSelected.isNotEmpty) {
        for (var timeslotSelected in timeslotListSelected) {
          var data = {
            'email': email,
            'time_slot_id': timeslotSelected.tutor_time_slot_id
          };

          var response = await http
              .post(
                  Uri.https(
                      authority, unencodedPath + 'delete_tutor_time_slot.php'),
                  headers: <String, String>{'authorization': basicAuth},
                  body: json.encode(data))
              .timeout(const Duration(seconds: 8));
          if (response.statusCode == 200) {
            var message = jsonDecode(response.body);
            if (message == 'Time slot successfully deleted') {
              totalCoursesSelected = totalCoursesSelected - 1;
            } else {
              errorMsg += "\nError deleting time slot: " + timeslotSelected.day;
            }
            // response not 200
          } else {
            errorMsg += "\nError deleting time slot: " + timeslotSelected.day;
          }
        }

        if (totalCoursesSelected == 0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Time slot successfully deleted"),
                actions: <Widget>[
                  TextButton(
                    child: new Text(
                      "OK",
                      style: TextStyle(color: ArgonColors.redUnito),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyTutorTimeslot()));
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text(errorMsg),
                actions: <Widget>[
                  TextButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error adding courses. Verify Your Connection.'),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    print("init my tutor timeslot");
    getTutorDetailFromWS(http.Client()).then((value) => {
          setState(() {
            tutor = value;
            for (var timeslot in value.time_slot) {
              timeslotList.add(TutorTimeslotModel.fromJson(timeslot));
            }
          })
        });
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose my tutor timeslot");
  }

  List<ChildItem> _buildList() {
    if (timeslotList != null) {
      return timeslotList
          .map((timeslot) => new ChildItem(timeslot, timeslotListSelected))
          .toList();
    } else
      return [];
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: provider.locale,
        supportedLocales: L10n.all,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        onGenerateRoute: RouteGenerator.generateRoute,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
                'My availability'), // Text(AppLocalizations.of(context).my_timeslot),
            backgroundColor: Color.fromRGBO(213, 21, 36, 1),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteTimeslots(timeslotListSelected);
                  }),
            ],
          ),
          drawer: ArgonDrawer("my-tutor-timeslot"),
          body: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              // height: 220,
              width: double.maxFinite,
              color: Colors.white,
              child: ListView(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                children: _buildList(),
              )),
          floatingActionButton: new FloatingActionButton(
            backgroundColor: ArgonColors.redUnito,
            child: new Icon(Icons.add),
            onPressed: () => {
              Navigator.pop(context),
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyTutorTimeslotAdd()))
            },
          ),
        ));
  }
}

// ignore: must_be_immutable
class ChildItem extends StatefulWidget {
  dynamic course;
  List<TutorTimeslotModel> courseListSelected = [];

  ChildItem(course, courseListSelected) {
    this.course = course;
    this.courseListSelected = courseListSelected;
  }

  @override
  ChildItemState createState() =>
      new ChildItemState(this.course, this.courseListSelected);
}

class ChildItemState extends State<ChildItem> {
  final TutorTimeslotModel timeslot;
  List<TutorTimeslotModel> timeslotListSelected = [];
  ChildItemState(this.timeslot, this.timeslotListSelected);

  String formatDate(date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(date);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
        elevation: 5,
        child: ListTile(
            onTap: () {
              if (timeslot.reserved == "0") {
                setState(() {
                  timeslot.selected = !this.timeslot.selected;
                });
                if (timeslot.selected) {
                  timeslotListSelected.add(this.timeslot);
                } else {
                  timeslotListSelected.remove(this.timeslot);
                }
              }
            },
            leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.black))),
                child: Icon(
                  Icons.timelapse,
                  color: Colors.green,
                )),
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      DateFormat('EEEE').format(DateTime.parse(timeslot.day)) +
                          " | " +
                          formatDate(DateTime.parse(timeslot.day)),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Text(timeslot.course_name.toUpperCase(),
                      style: TextStyle(fontStyle: FontStyle.italic)),
                ]),
            subtitle: Text(timeslot.hour_from + ' - ' + timeslot.hour_to,
                style: TextStyle(color: Colors.black, fontSize: 15)),
            trailing: (timeslot.reserved == "0")
                ? (timeslot.selected)
                    ? Icon(Icons.check_box)
                    : Icon(Icons.check_box_outline_blank)
                : Icon(
                    Icons.block,
                    color: ArgonColors.redUnito,
                  )));
  }
}
