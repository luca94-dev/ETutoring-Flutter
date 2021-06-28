import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/controller/controllerWS.dart';
import 'package:e_tutoring/model/tutorLesson.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'my-tutor-lesson.dart';

class MyTutorLessonToday extends StatefulWidget {
  @override
  MyTutorLessonTodayState createState() => new MyTutorLessonTodayState();
}

class MyTutorLessonTodayState extends State<MyTutorLessonToday> {
  @override
  void initState() {
    super.initState();
    print("init my tutor lesson today");
  }

  String formatDate(date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(date);
    return formatted;
  }

  String getNowDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    return formatted;
  }

  @override
  void dispose() {
    print("dispose my tutor-lesson today");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).private_lesson + ": " + getNowDate()),
        backgroundColor: Color.fromRGBO(213, 21, 36, 1),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyTutorLesson()));
            }),
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          // height: 220,
          width: double.maxFinite,
          color: Colors.white,
          child: FutureBuilder<List<TutorLessonModel>>(
              future: getTutorLessonTodayFromWS(http.Client()),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TutorLessonModel>> lessonSnapshot) {
                List<Widget> children;
                if (lessonSnapshot.hasData) {
                  return ListView.builder(
                    itemCount: lessonSnapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                          elevation: 5,
                          child: ListTile(
                            leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0, color: Colors.black))),
                                child: Icon(Icons.calendar_today)),
                            title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    lessonSnapshot.data[index].course_name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      lessonSnapshot.data[index]
                                              .student[0]['firstname']
                                              .toString()
                                              .toUpperCase() +
                                          ' ' +
                                          lessonSnapshot.data[index]
                                              .student[0]['lastname']
                                              .toString()
                                              .toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(DateFormat('EEEE').format(DateTime.parse(
                                          lessonSnapshot.data[index].day)) +
                                      " | " +
                                      formatDate(DateTime.parse(
                                          lessonSnapshot.data[index].day))),
                                ]),
                            subtitle: Text(
                                lessonSnapshot.data[index].hour_from +
                                    " - " +
                                    lessonSnapshot.data[index].hour_to),
                          ));
                    },
                  );
                } else if (lessonSnapshot.hasError) {
                  children = <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text('Error: ${lessonSnapshot.error}'),
                    )
                  ];
                } else {
                  children = const <Widget>[
                    SizedBox(
                      child: CircularProgressIndicator(
                          backgroundColor: ArgonColors.redUnito),
                      width: 60,
                      height: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text('Awaiting result...',
                          style: TextStyle(color: ArgonColors.redUnito)),
                    )
                  ];
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              })),
    );
  }
}
