import 'package:e_tutoring/controller/controllerWS.dart';
import 'package:e_tutoring/model/tutorModel.dart';
import 'package:e_tutoring/screens/tutorDetail.dart';
import 'package:e_tutoring/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'package:e_tutoring/widgets/star_widget.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class Tutor extends StatefulWidget {
  final String courseName;
  Tutor({Key key, this.courseName}) : super(key: key);

  @override
  _TutorState createState() => _TutorState();
}

class _TutorState extends State<Tutor> {
  List<TutorModel> tutorList = [];

  @override
  void initState() {
    super.initState();
    print("init tutor widget");
    _IsSearching = false;
    if (widget.courseName != null) {
      _IsSearching = true;
      _searchText = widget.courseName;
      searchController.text = _searchText;
    }
    getTutorSearchFromWS(http.Client()).then((value) => {
          setState(() {
            tutorList = value;
            // print(tutorList);
          })
        });
  }

  @override
  void dispose() {
    print("dispose tutor widget");
    super.dispose();
  }

  final searchController = TextEditingController();
  // ignore: non_constant_identifier_names
  bool _IsSearching;
  String _searchText = "";
  Widget appBarTitle = new Text(
    "Tutor",
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  _TutorState() {
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

  List<ChildItem> _buildList() {
    if (tutorList != null) {
      return tutorList.map((tutor) => new ChildItem(tutor)).toList();
    } else
      return [];
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return tutorList.map((tutor) => new ChildItem(tutor)).toList();
    } else {
      List<TutorModel> _searchList = [];
      for (int i = 0; i < tutorList.length; i++) {
        TutorModel tutor = tutorList.elementAt(i);
        // print(tutor);
        if (tutor
            .toString()
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          _searchList.add(tutor);
        }
      }
      // print(_searchList);
      return _searchList.map((tutor) => new ChildItem(tutor)).toList();
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
        "Tutor",
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
      drawer: ArgonDrawer("tutor"),
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
                                    .result_tutor_not_found,
                                style: TextStyle(fontSize: 18)),
                          ])
                    ]
                  : _buildSearchList())
              : _buildList(),
        ),
      ),
    );
  }
}

class ChildItem extends StatelessWidget {
  final dynamic tutor;

  ChildItem(this.tutor);
  @override
  Widget build(BuildContext context) {
    // return new ListTile(title: new Text(this.name));
    return new Card(
        elevation: 5,
        child: ListTile(
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(this.tutor.firstname + " " + this.tutor.lastname,
                    style: new TextStyle(fontSize: 20.0)),
                Row(children: [
                  Icon(Icons.email),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(this.tutor.email,
                          style: TextStyle(fontSize: 13)),
                    ),
                  ),
                ]),
                Row(children: [
                  Icon(Icons.location_on),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text(this.tutor.residence_city))),
                ]),
                Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      StarWidget(tutorData: this.tutor, pre: false, post: true)
                    ]),
              ]),
          subtitle: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: this.tutor.courses.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                          this.tutor.courses[index]['course_name'].toString(),
                          style: TextStyle(color: Colors.black));
                    })
              ]),
          leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.black))),
              child: CircleAvatar(
                  backgroundImage: new AssetImage("assets/img/image.jpg"))),
          // trailing: Icon(Icons.star),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TutorDetail(this.tutor)),
            );
          },
        ));
  }
}
