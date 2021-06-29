import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/controller/controllerWS.dart';
import 'package:e_tutoring/l10n/l10n.dart';
import 'package:e_tutoring/model/privatelessonModel.dart';
import 'package:e_tutoring/provider/locale_provider.dart';
import 'package:e_tutoring/screens/user-private-lesson-today.dart';
import 'package:e_tutoring/utils/routeGenerator.dart';
import 'package:e_tutoring/screens/user-review-add.dart';
import 'package:e_tutoring/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserPrivateLesson extends StatefulWidget {
  @override
  UserPrivateLessonState createState() => new UserPrivateLessonState();
}

class UserPrivateLessonState extends State<UserPrivateLesson> {
  List<PrivatelessonModel> lessonList = [];
  String searchString = "";
  final searchController = TextEditingController();
  // ignore: non_constant_identifier_names
  bool _IsSearching;
  String _searchText = "";
  Widget appBarTitle = new Text(
    "My Lessons",
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = new GlobalKey<ScaffoldState>();

  UserPrivateLessonState() {
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
    print("init user private lesson");
    _IsSearching = false;
    getPrivateLessonFromWS(http.Client()).then((value) => {
          setState(() {
            lessonList = value;
          })
        });
  }

  @override
  void dispose() {
    print("dispose user private lesson");
    super.dispose();
  }

  List<ChildItem> _buildList() {
    if (lessonList != null) {
      return lessonList.map((lesson) => new ChildItem(lesson)).toList();
    } else
      return [];
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return lessonList.map((course) => new ChildItem(course)).toList();
    } else {
      List<PrivatelessonModel> _searchList = [];
      for (int i = 0; i < lessonList.length; i++) {
        PrivatelessonModel course = lessonList.elementAt(i);
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
        "My Lessons",
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
          appBar: buildBar(context),
          drawer: ArgonDrawer("private-lesson"),
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
                                        .result_not_found,
                                    style: TextStyle(fontSize: 18)),
                              ])
                        ]
                      : _buildSearchList())
                  : (_buildList().length == 0
                      ? [
                          const SizedBox(height: 30),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.image_search),
                                Text(AppLocalizations.of(context).lesson_empty,
                                    style: TextStyle(fontSize: 18)),
                              ])
                        ]
                      : _buildList()),
            ),
          ),
          floatingActionButton: new FloatingActionButton(
            backgroundColor: ArgonColors.redUnito,
            child: Text("today".toUpperCase()),
            onPressed: () => {
              Navigator.pop(context),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserPrivateLessonToday()))
            },
          ),
        ));
  }
}

class ChildItem extends StatelessWidget {
  final dynamic lesson;
  ChildItem(this.lesson);

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
            if (DateTime.parse(lesson.day).isBefore(DateTime.now())) {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserReviewAdd(lesson),
                ),
              );
            }
          },
          leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.black))),
              child: Icon(Icons.calendar_today)),
          trailing: DateTime.parse(lesson.day).isBefore(DateTime.now())
              ? Icon(Icons.rate_review)
              : Icon(Icons.timelapse),
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  lesson.course_name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                    lesson.tutor[0]['firstname'].toString().toUpperCase() +
                        ' ' +
                        lesson.tutor[0]['lastname'].toString().toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(DateFormat('EEEE').format(DateTime.parse(lesson.day)) +
                    " | " +
                    formatDate(DateTime.parse(lesson.day))),
              ]),
          subtitle: Text(lesson.hour_from + ' - ' + lesson.hour_to),
        ));
  }
}
