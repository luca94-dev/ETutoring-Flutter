import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/model/tutorTimeslotModel.dart';
import 'package:e_tutoring/screens/user-private-lesson.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:e_tutoring/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class UserTutorTimeslot extends StatefulWidget {
  dynamic tutorData;

  UserTutorTimeslot(dynamic tutorData) {
    this.tutorData = tutorData;
  }

  @override
  UserTutorTimeslotState createState() => new UserTutorTimeslotState(tutorData);
}

class UserTutorTimeslotState extends State<UserTutorTimeslot> {
  dynamic tutorData;
  UserTutorTimeslotState(dynamic tutorData) {
    this.tutorData = tutorData;
  }
  List<TutorTimeslotModel> timeslotListSelected = [];
  List<TutorTimeslotModel> timeslotList = [];

  // CONTROLLER
  Future addLessons(
      List<TutorTimeslotModel> timeslotListSelected, tutorId) async {
    try {
      int totalTimeslotSelected = timeslotListSelected.length;
      String errorMsg = "";
      String email = await UserSecureStorage.getEmail();
      if (timeslotListSelected.isNotEmpty) {
        for (var timeslotSelected in timeslotListSelected) {
          var data = {
            'email': email, // user email
            'course_id': timeslotSelected.course_id,
            'tutor_time_slot_id': timeslotSelected.tutor_time_slot_id,
            'tutor_id': tutorId
          };

          var response = await http
              .post(
                  Uri.https(
                      authority, unencodedPath + 'add_private_lesson.php'),
                  headers: <String, String>{'authorization': basicAuth},
                  body: json.encode(data))
              .timeout(const Duration(seconds: 8));
          if (response.statusCode == 200) {
            // print(response.body);
            var message = jsonDecode(response.body);
            if (message == 'Add lesson successfully') {
              totalTimeslotSelected = totalTimeslotSelected - 1;
            } else {
              errorMsg += "\nError adding time slot for : " +
                  timeslotSelected.course_name;
            }
            // response not 200
          } else {
            errorMsg += "\nError adding time slot for : " +
                timeslotSelected.course_name;
          }
        }

        if (totalTimeslotSelected == 0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Successfully added lesson"),
                actions: <Widget>[
                  TextButton(
                    child: new Text(
                      "OK",
                      style: TextStyle(color: ArgonColors.redUnito),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new UserPrivateLesson()));
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
        content: Text('Error adding lesson. Verify Your Connection.'),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    print("init user tutor time slot");
    setState(() {
      for (var timeslot in this.tutorData.time_slot) {
        timeslotList.add(TutorTimeslotModel.fromJson(timeslot));
      }
    });
  }

  @override
  void dispose() {
    print("dispose user tutor time slot");
    super.dispose();
  }

  List<ChildItem> _buildList() {
    if (timeslotList != null) {
      return timeslotList
          .map((timeslot) =>
              new ChildItem(tutorData, timeslot, timeslotListSelected))
          .toList();
    } else
      return [];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(this.tutorData.firstname +
            " " +
            this.tutorData.lastname +
            " " +
            AppLocalizations.of(context).time_slot),
        backgroundColor: Color.fromRGBO(213, 21, 36, 1),
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          // height: 220,
          width: double.maxFinite,
          color: Colors.white,
          child: ListView(
            padding: new EdgeInsets.symmetric(vertical: 8.0),
            children: (this.timeslotList.length == 0
                ? [
                    const SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.image_search),
                          Text(
                              AppLocalizations.of(context)
                                  .result_tutor_not_found_time_slot,
                              style: TextStyle(fontSize: 18)),
                        ])
                  ]
                : _buildList()),
          )),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: ArgonColors.redUnito,
        child: new Icon(Icons.add),
        onPressed: () => {addLessons(this.timeslotListSelected, tutorData.id)},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

// ignore: must_be_immutable
class ChildItem extends StatefulWidget {
  dynamic tutorData;
  dynamic course;
  List<TutorTimeslotModel> courseListSelected = [];

  ChildItem(tutorData, course, courseListSelected) {
    this.tutorData = tutorData;
    this.course = course;
    this.courseListSelected = courseListSelected;
  }

  @override
  ChildItemState createState() =>
      new ChildItemState(this.tutorData, this.course, this.courseListSelected);
}

class ChildItemState extends State<ChildItem> {
  dynamic tutorData;
  final TutorTimeslotModel timeslot;
  List<TutorTimeslotModel> timeslotListSelected = [];
  ChildItemState(this.tutorData, this.timeslot, this.timeslotListSelected);

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
                child: timeslot.reserved == "0"
                    ? Icon(
                        Icons.timelapse,
                        color: Colors.green,
                      )
                    : Icon(Icons.timelapse, color: ArgonColors.redUnito)),
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(timeslot.course_name.toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ArgonColors.black)),
                  Text(
                      DateFormat('EEEE').format(DateTime.parse(timeslot.day)) +
                          " | " +
                          formatDate(DateTime.parse(timeslot.day)),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold))
                ]),
            subtitle: Text(timeslot.hour_from + ' - ' + timeslot.hour_to,
                style: TextStyle(color: Colors.black, fontSize: 15)),
            trailing: (timeslot.reserved == "0" &&
                    DateTime.parse(timeslot.day).isAfter(DateTime.now()))
                ? (timeslot.selected)
                    ? Icon(Icons.check_box)
                    : Icon(Icons.check_box_outline_blank)
                : Icon(
                    Icons.block,
                    color: ArgonColors.redUnito,
                  )));
  }
}
