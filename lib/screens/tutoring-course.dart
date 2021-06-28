import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/controller/controllerWS.dart';
import 'package:e_tutoring/model/courseModel.dart';
import 'package:e_tutoring/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'courseDetail.dart';
import 'package:http/http.dart' as http;

class TutoringCourse extends StatefulWidget {
  @override
  TutoringCourseState createState() => new TutoringCourseState();
}

class TutoringCourseState extends State<TutoringCourse> {
  List<CourseModel> courseList;

  String searchString = "";

  final searchController = TextEditingController();
  // ignore: non_constant_identifier_names
  bool _IsSearching;
  String _searchText = "";
  Widget appBarTitle = new Text(
    "Tutoring Course",
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = new GlobalKey<ScaffoldState>();

  TutoringCourseState() {
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

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
    getUserCourseSearchFromWS(http.Client()).then((value) => {
          setState(() {
            courseList = value;
            // print(courseList);
          })
        });
  }

  List<ChildItem> _buildList() {
    if (courseList != null) {
      return courseList.map((course) => new ChildItem(course)).toList();
    } else
      return [];
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return courseList.map((course) => new ChildItem(course)).toList();
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
      return _searchList.map((course) => new ChildItem(course)).toList();
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
        "Tutoring Course",
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
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildBar(context),
      drawer: ArgonDrawer("Tutoring Course"),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        // height: 220,
        width: double.maxFinite,
        color: Colors.white,
        child: ListView(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          children: _IsSearching ? _buildSearchList() : _buildList(),
        ),
      ),
    );
  }
}

class ChildItem extends StatelessWidget {
  final dynamic course;
  ChildItem(this.course);
  @override
  Widget build(BuildContext context) {
    // return new ListTile(title: new Text(this.name));
    return new Card(
        elevation: 5,
        child: ListTile(
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(this.course.course_name.toUpperCase(),
                    style: new TextStyle(fontSize: 18.0)),
                Row(children: [
                  Icon(Icons.event_available),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(this.course.enrollment_year),
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
          leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.black))),
              child: Icon(Icons.school)),
          trailing: Icon(
            Icons.calendar_today,
            color: Colors.green,
          ),
          onTap: () {
            // print(this.course.toString());
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CourseDetail(this.course)),
            );
          },
        ));
  }
}
