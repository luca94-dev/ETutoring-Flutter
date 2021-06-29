import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/controller/course_controllerWS.dart';
import 'package:e_tutoring/model/courseModel.dart';
import 'package:e_tutoring/screens/my-tutor-course.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:e_tutoring/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class TutorCourse extends StatefulWidget {
  @override
  TutorCourseState createState() => new TutorCourseState();
}

class TutorCourseState extends State<TutorCourse> {
  List<CourseModel> courseList;
  List<CourseModel> courseListSelected = [];

  String searchString = "";

  final searchController = TextEditingController();
  // ignore: non_constant_identifier_names
  bool _IsSearching;
  String _searchText = "";
  Widget appBarTitle = new Text(
    "Add Course",
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  TutorCourseState() {
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = searchController.text;
        });
      }
    });
  }

  // CONTROLLER
  Future addCourses(List<CourseModel> courseListSelected) async {
    try {
      int totalCoursesSelected = courseListSelected.length;
      String errorMsg = "";
      String email = await UserSecureStorage.getEmail();
      if (courseListSelected.isNotEmpty) {
        for (var courseSelected in courseListSelected) {
          var data = {'email': email, 'course_id': courseSelected.course_id};

          var response = await http
              .post(
                  Uri.https(authority, unencodedPath + 'add_tutor_course.php'),
                  headers: <String, String>{'authorization': basicAuth},
                  body: json.encode(data))
              .timeout(const Duration(seconds: 8));
          if (response.statusCode == 200) {
            // print(response.body);
            var message = jsonDecode(response.body);
            if (message == 'Add course successfully') {
              totalCoursesSelected = totalCoursesSelected - 1;
            } else if (message == 'Course already in your list') {
              totalCoursesSelected = totalCoursesSelected - 1;
            } else {
              errorMsg +=
                  "\nError adding course: " + courseSelected.course_name;
            }
            // response not 200
          } else {
            errorMsg += "\nError adding course: " + courseSelected.course_name;
          }
        }

        if (totalCoursesSelected == 0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Successfully added courses"),
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
                              builder: (context) => new MyTutorCourse()));
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
    print("init tutor course");
    _IsSearching = false;
    getAllCourseFromWS(http.Client()).then((value) => {
          setState(() {
            courseList = value;
          })
        });
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose tutor course");
  }

  List<ChildItem> _buildList() {
    if (courseList != null) {
      return courseList
          .map((course) => new ChildItem(course, courseListSelected))
          .toList();
    } else
      return [];
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return courseList
          .map((course) => new ChildItem(course, courseListSelected))
          .toList();
    } else {
      List<CourseModel> _searchList = [];
      for (int i = 0; i < courseList.length; i++) {
        CourseModel course = courseList.elementAt(i);
        if (course
            .toString()
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          _searchList.add(course);
        }
      }
      // print(_searchList);
      return _searchList
          .map((course) => new ChildItem(course, courseListSelected))
          .toList();
    }
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Course",
        style: new TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      searchController.clear();
    });
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
        backgroundColor: Color.fromRGBO(213, 21, 36, 1),
        centerTitle: true,
        title: appBarTitle,
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = new TextField(
                    controller: searchController,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.white),
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white)),
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
          /*IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // print(this.courseListSelected);
                addCourses(this.courseListSelected);
              }),*/
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildBar(context),
      drawer: new ArgonDrawer("tutor-course"),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        // height: 220,
        width: double.maxFinite,
        color: Colors.white,
        child: ListView(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          children: _IsSearching
              ? (_buildSearchList().length == 0
                  ? [
                      const SizedBox(height: 30),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.image_search),
                            Text(
                                AppLocalizations.of(context)
                                    .result_course_not_found,
                                style: TextStyle(fontSize: 18)),
                          ])
                    ]
                  : _buildSearchList())
              : _buildList(),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: ArgonColors.redUnito,
        child: new Icon(Icons.add),
        onPressed: () => {addCourses(this.courseListSelected)},
      ),
    );
  }
}

// ignore: must_be_immutable
class ChildItem extends StatefulWidget {
  dynamic course;
  List<CourseModel> courseListSelected = [];

  ChildItem(course, courseListSelected) {
    this.course = course;
    this.courseListSelected = courseListSelected;
  }

  @override
  ChildItemState createState() =>
      new ChildItemState(this.course, this.courseListSelected);
}

class ChildItemState extends State<ChildItem> {
  final CourseModel course;
  List<CourseModel> courseListSelected = [];
  ChildItemState(this.course, this.courseListSelected);
  @override
  Widget build(BuildContext context) {
    return new Card(
        elevation: 5,
        child: ListTile(
          onTap: () {
            setState(() {
              this.course.selected = !this.course.selected;
            });
            if (this.course.selected) {
              this.courseListSelected.add(this.course);
            } else {
              this.courseListSelected.remove(this.course);
            }
          },
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(this.course.course_name.toUpperCase(),
                    style: new TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold)),
                Row(children: [
                  Icon(Icons.home),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(this.course.department),
                    ),
                  ),
                ]),
              ]),
          subtitle: Row(children: <Widget>[
            Text('CFU: ' + this.course.course_cfu.toUpperCase(),
                style: TextStyle(
                  color: ArgonColors.redUnito,
                )),
          ]),
          trailing: (this.course.selected)
              ? Icon(Icons.check_box)
              : Icon(Icons.check_box_outline_blank),
          leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.black))),
              child: Icon(Icons.school)),
        ));
  }
}
