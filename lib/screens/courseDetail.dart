import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/controller/controllerWS.dart';
import 'package:e_tutoring/model/courseModel.dart';
import 'package:e_tutoring/screens/tutor.dart';
import 'package:flutter/material.dart';
import 'string_extension.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class CourseDetail extends StatefulWidget {
  dynamic courseData;

  CourseDetail(dynamic course) {
    this.courseData = course;
  }

  @override
  CourseDetailState createState() => new CourseDetailState(courseData);
}

class CourseDetailState extends State<CourseDetail> {
  dynamic courseData;
  CourseDetailState(dynamic course) {
    this.courseData = course;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text(courseData.course_name.toString().capitalize()),
          backgroundColor: Color.fromRGBO(213, 21, 36, 1)),
      // drawer: ArgonDrawer("courseDetail"),
      body: Stack(children: <Widget>[
        SafeArea(
            child: ListView(children: [
          Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(children: <Widget>[
                      Container(
                        child: Card(
                            // color: Color.fromRGBO(205, 205, 205, 1),
                            child: Padding(
                          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    FutureBuilder<CourseModel>(
                                      future: getCourseDetailFromWS(
                                          http.Client(),
                                          this.courseData.course_id),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<CourseModel> course) {
                                        List<Widget> children;
                                        if (course.hasData) {
                                          // print(course.data);
                                          children = <Widget>[
                                            Container(
                                                color: Color.fromRGBO(
                                                    205, 205, 205, 1),
                                                child: DataTable(
                                                  dataRowHeight: 60,
                                                  dataRowColor:
                                                      MaterialStateColor
                                                          .resolveWith(
                                                              (states) =>
                                                                  Colors.white),
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
                                                          'Course',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                        )),
                                                        DataCell(Text(
                                                            "${course.data.course_name}"
                                                                .capitalize(),
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                      ],
                                                    ),
                                                    DataRow(
                                                      cells: <DataCell>[
                                                        DataCell(Text('CFU',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .redAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15))),
                                                        DataCell(Text(
                                                            "${course.data.course_cfu}",
                                                            style: TextStyle(
                                                                fontSize: 15))),
                                                      ],
                                                    ),
                                                    DataRow(
                                                      cells: <DataCell>[
                                                        DataCell(Text(
                                                            'Enrollment year',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .redAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15))),
                                                        DataCell(
                                                          Text(
                                                            "${course.data.enrollment_year}",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    DataRow(
                                                      cells: <DataCell>[
                                                        DataCell(Text(
                                                            'Department',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .redAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                        DataCell(Text(
                                                            "${course.data.department}",
                                                            style: TextStyle(
                                                                fontSize: 15))),
                                                      ],
                                                    ),
                                                    DataRow(
                                                      cells: <DataCell>[
                                                        DataCell(Text(
                                                          'Curriculum',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                        )),
                                                        DataCell(Text(
                                                            "${course.data.curriculum}"
                                                                .capitalize(),
                                                            style: TextStyle(
                                                                fontSize: 15))),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                            SizedBox(
                                              height: 50,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                //minimumSize: Size.fromHeight(52),
                                                primary: ArgonColors.redUnito,
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Tutor(
                                                              courseName: course
                                                                  .data
                                                                  .course_name,
                                                            )));
                                              },
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16.0,
                                                      right: 16.0,
                                                      top: 12,
                                                      bottom: 12),
                                                  child: Text(
                                                      AppLocalizations
                                                              .of(context)
                                                          .tutor,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16.0))),
                                            ),
                                            SizedBox(
                                              height: 50,
                                            ),
                                          ];
                                        } else if (course.hasError) {
                                          children = <Widget>[
                                            const Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                              size: 60,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15),
                                              child: Text(
                                                  'Error: ${course.error}'),
                                            )
                                          ];
                                        } else {
                                          children = const <Widget>[
                                            SizedBox(
                                              child: CircularProgressIndicator(
                                                  backgroundColor:
                                                      ArgonColors.redUnito),
                                              width: 60,
                                              height: 60,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 15),
                                              child: Text('Awaiting result...',
                                                  style: TextStyle(
                                                      color: ArgonColors
                                                          .redUnito)),
                                            )
                                          ];
                                        }
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: children,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                      ),
                    ]),
                  ])),
        ]))
      ]),
    );
    /*return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Home Page"),
        ),
        body: new Center(
          child: new Text("Home Page"),
        ),
      ),
    );*/
  }

  /*Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(courseData.course_name.toString().capitalize()),
            backgroundColor: Color.fromRGBO(213, 21, 36, 1)),
        drawer: ArgonDrawer("courseDetail"),
        body: Container());
  }*/
}
