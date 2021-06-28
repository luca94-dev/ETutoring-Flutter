import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/controller/controllerWS.dart';
import 'package:e_tutoring/model/tutorCourseModel.dart';
import 'package:e_tutoring/screens/my-tutor-timeslot.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MyTutorTimeslotAdd extends StatefulWidget {
  @override
  MyTutorTimeslotAddState createState() => new MyTutorTimeslotAddState();
}

class MyTutorTimeslotAddState extends State<MyTutorTimeslotAdd> {
  DateTime currentDate = DateTime.now();
  TimeOfDay _timeFrom = TimeOfDay(hour: 16, minute: 00);
  TimeOfDay _timeTo = TimeOfDay(hour: 18, minute: 00);
  List<TutorCourseModel> courseList = [];
  TutorCourseModel courseSelected;

  @override
  void initState() {
    super.initState();
    print("init my tutor timeslot add");
    getTutorDetailFromWS(http.Client()).then((value) => {
          setState(() {
            for (var course in value.courses) {
              courseList.add(TutorCourseModel.fromJson(course));
            }
          })
        });
  }

  @override
  void dispose() {
    super.dispose();
    print("my tutor timeslot dispose");
  }

// CONTROLLER
  Future addTimeslot(courseId, day, houFrom, hourTo) async {
    try {
      String email = await UserSecureStorage.getEmail();

      var data = {
        'email': email,
        'course_id': courseId,
        'day': day,
        'hour_from': houFrom,
        'hour_to': hourTo
      };

      var response = await http
          .post(Uri.https(authority, unencodedPath + 'add_tutor_time_slot.php'),
              headers: <String, String>{'authorization': basicAuth},
              body: json.encode(data))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);
        // print(response.body);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(message),
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
                        new MaterialPageRoute(
                            builder: (context) => new MyTutorTimeslot()));
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
              title: new Text("Error adding availability"),
              actions: <Widget>[
                TextButton(
                  child: new Text(
                    "OK",
                    style: TextStyle(color: ArgonColors.redUnito),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error adding courses. Verify Your Connection.'),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  Future<void> _selectTimeFrom(BuildContext context) async {
    final TimeOfDay newTime = await showTimePicker(
        context: context,
        initialTime: _timeFrom,
        //initialEntryMode: TimePickerEntryMode.input,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.red,
                  primaryColorDark: Colors.red,
                  accentColor: Colors.red,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child,
            ),
          );
        });
    if (newTime != null) {
      setState(() {
        _timeFrom = newTime;
      });
    }
  }

  List<ChildItem> _buildList() {
    if (courseList != null) {
      return courseList.map((course) => new ChildItem(course)).toList();
    } else
      return [];
  }

  Future<void> _selectTimeTo(BuildContext context) async {
    final TimeOfDay newTime = await showTimePicker(
        context: context,
        initialTime: _timeTo,
        //initialEntryMode: TimePickerEntryMode.input,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.red,
                  primaryColorDark: Colors.red,
                  accentColor: Colors.red,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child,
            ),
          );
        });
    if (newTime != null) {
      setState(() {
        _timeTo = newTime;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2050),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.red,
                primaryColorDark: Colors.red,
                accentColor: Colors.red,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }

  String formatDate(date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(date);
    return formatted;
  }

  String formatDateDayFirst(date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(date);
    return formatted;
  }

  String formatTime(timeHour) {
    timeHour = timeHour.replaceAll(' ', '');
    DateFormat df;
    DateTime dt;
    df = DateFormat("h:mma");
    dt = df.parse(timeHour);
    return DateFormat('HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add availability"),
        backgroundColor: Color.fromRGBO(213, 21, 36, 1),
        actions: <Widget>[],
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyTutorTimeslot()));
            }),
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Add availability",
              style: TextStyle(
                  color: ArgonColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 50),
          DataTable(
              dataRowHeight: 50,
              dataRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
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
                    DataCell(
                      ElevatedButton(
                        onPressed: () => {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      "My courses"), // Text(AppLocalizations.of(context).my_courses),
                                  content: Container(
                                    height:
                                        300.0, // Change as per your requirement
                                    width:
                                        300.0, // Change as per your requirement
                                    child: ListView(
                                      padding: new EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      children: _buildList(),
                                    ),
                                  ),
                                );
                              }).then((courseValue) => {
                                setState(() {
                                  this.courseSelected = courseValue;
                                }),
                              }),
                        },
                        child: Text('COURSE',
                            style: TextStyle(color: ArgonColors.redUnito)),
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                      ),
                    ),
                    DataCell(
                      this.courseSelected != null
                          ? Text(this.courseSelected.course_name)
                          : Text("-"),
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text('DATE',
                              style: TextStyle(color: ArgonColors.redUnito)),
                          // style: ElevatedButton.styleFrom(primary: Colors.white),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.white))))),
                    ),
                    DataCell(
                      Text(formatDateDayFirst(
                              DateTime.parse(formatDate(currentDate)))
                          .toString()),
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      ElevatedButton(
                          onPressed: () => _selectTimeFrom(context),
                          child: Text('INIT HOUR',
                              style: TextStyle(color: ArgonColors.redUnito)),
                          style:
                              ElevatedButton.styleFrom(primary: Colors.white)),
                    ),
                    DataCell(
                      Text(
                        _timeFrom.format(context),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      ElevatedButton(
                          onPressed: () => _selectTimeTo(context),
                          child: Text('END HOUR',
                              style: TextStyle(color: ArgonColors.redUnito)),
                          style:
                              ElevatedButton.styleFrom(primary: Colors.white)),
                    ),
                    DataCell(
                      Text(
                        _timeTo.format(context),
                      ),
                    ),
                  ],
                ),
              ]),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => {
              addTimeslot(
                  this.courseSelected != null
                      ? this.courseSelected.course_id
                      : 0,
                  formatDate(currentDate).toString(),
                  _timeFrom.format(context),
                  _timeTo.format(context))
            },
            child: Text("Add availability", style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              // minimumSize: Size.fromHeight(40),
              primary: ArgonColors.redUnito,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

// ignore: must_be_immutable
class ChildItem extends StatefulWidget {
  dynamic course;

  ChildItem(course) {
    this.course = course;
  }

  @override
  ChildItemState createState() => new ChildItemState(this.course);
}

class ChildItemState extends State<ChildItem> {
  final TutorCourseModel course;

  ChildItemState(this.course);
  @override
  Widget build(BuildContext context) {
    return new Card(
        elevation: 5,
        child: ListTile(
          onTap: () {
            Navigator.pop(context, course);
          },
          leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.black))),
              child: Icon(
                Icons.school,
                color: Colors.green,
              )),
          title: Text('${course.course_name}',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          subtitle: Text('${course.department}',
              style: TextStyle(color: Colors.black, fontSize: 15)),
        ));
  }
}
