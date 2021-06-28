import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/screens/review.dart';
import 'package:e_tutoring/screens/tutor.dart';
import 'package:e_tutoring/screens/user-tutor-time-slot.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:e_tutoring/widgets/star_widget.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TutorDetail extends StatefulWidget {
  dynamic tutorData;

  TutorDetail(dynamic tutor) {
    this.tutorData = tutor;
  }

  @override
  _TutorDetailState createState() => new _TutorDetailState(tutorData);
}

class _TutorDetailState extends State<TutorDetail> {
  dynamic tutorData;
  _TutorDetailState(dynamic tutor) {
    this.tutorData = tutor;
  }

  @override
  void initState() {
    super.initState();
    print("init tutor detail widget");
  }

  @override
  void dispose() {
    print("dispose tutor detail widget");
    super.dispose();
  }

  String formatDate(date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(date);
    return formatted;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(205, 205, 205, 1),
      appBar: AppBar(
        title: Text(this.tutorData.firstname + " " + this.tutorData.lastname),
        backgroundColor: Color.fromRGBO(213, 21, 36, 1),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Tutor()));
            }),
        actions: <Widget>[
          // LanguagePickerWidget(),
          IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserTutorTimeslot(tutorData)),
                );
              }),
          /*IconButton(
              icon: Icon(Icons.chat),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatDetail()),
                );
              }),*/
          IconButton(
              icon: Icon(Icons.rate_review),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Review(tutorData)),
                );
              }),
        ],
      ),
      body: Stack(children: <Widget>[
        Card(
          child: ListView(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                // leading: Icon(Icons.person),
                title: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: new BoxDecoration(
                          border: new Border.all(
                            color: Colors.white,
                            width: 10.0,
                          ),
                          image: new DecorationImage(
                              //fit: BoxFit.fill,
                              image: new AssetImage('assets/img/image.jpg')),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ]),
                subtitle: Column(
                  children: <Widget>[
                    Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.person),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 15.0, top: 0.0),
                              child: Text(
                                  this.tutorData.firstname +
                                      " " +
                                      this.tutorData.lastname,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15))),
                        ]),
                    Row(
                        // mainAxisAlignment: MainAxisAlignment.left,
                        children: <Widget>[
                          Icon(Icons.email),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 15.0, top: 0.0),
                              child: Text(this.tutorData.email,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15))),
                        ]),
                    Row(
                        // mainAxisAlignment: MainAxisAlignment.left,
                        children: <Widget>[
                          Icon(Icons.smartphone),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 15.0, top: 0.0),
                              child: Text(this.tutorData.phone_number,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15))),
                        ]),
                    Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.location_on),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 15.0, top: 0.0),
                              child: Text(this.tutorData.residence_city,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15))),
                        ]),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 15.0, top: 15.0),
                        child: Text(AppLocalizations.of(context).description,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 15.0, top: 2.0),
                              child: Text(this.tutorData.description,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16)))
                        ]),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 15.0, top: 15.0),
                        child: Text(AppLocalizations.of(context).courses,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                    Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: this.tutorData.courses.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    leading: Icon(Icons.school),
                                    title: Text(this
                                        .tutorData
                                        .courses[index]['course_name']
                                        .toString()));
                              })
                        ]),
                    /* Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 15.0, top: 15.0),
                        child: Text(AppLocalizations.of(context).time_slot,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                    Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: this.tutorData.time_slot.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    leading: Icon(Icons.calendar_today),
                                    title: Text(formatDate(DateTime.parse(this
                                            .tutorData
                                            .time_slot[index]['day']
                                            .toString())) +
                                        " | " +
                                        this
                                            .tutorData
                                            .time_slot[index]['hour_from']
                                            .toString() +
                                        " - " +
                                        this
                                            .tutorData
                                            .time_slot[index]['hour_to']
                                            .toString()));
                              })
                        ]),*/
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 15.0, top: 15.0),
                        child: Text(AppLocalizations.of(context).reviews,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          StarWidget(
                              tutorData: this.tutorData, pre: true, post: true)
                        ]),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, right: 15.0, top: 20.0, bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: ArgonColors.redUnito,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        label: Text(
                            AppLocalizations.of(context)
                                .conctact_me
                                .toUpperCase(),
                            style: TextStyle(
                                color: ArgonColors.white, fontSize: 20)),
                        icon: Icon(Icons.chat),
                        onPressed: () {},
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ]),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: ArgonColors.redUnito,
        child: new Icon(Icons.calendar_today),
        onPressed: () => {
          // Navigator.pop(context),
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserTutorTimeslot(this.tutorData)))
        },
      ),
    );
  }
}
