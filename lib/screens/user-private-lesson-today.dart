import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/controller/private_lesson_controllerWS.dart';
import 'package:e_tutoring/l10n/l10n.dart';
import 'package:e_tutoring/model/privatelessonModel.dart';
import 'package:e_tutoring/provider/locale_provider.dart';
import 'package:e_tutoring/screens/user-private-lesson.dart';
import 'package:e_tutoring/utils/routeGenerator.dart';
import 'package:e_tutoring/screens/user-review-add.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserPrivateLessonToday extends StatefulWidget {
  @override
  UserPrivateLessonTodayState createState() =>
      new UserPrivateLessonTodayState();
}

class UserPrivateLessonTodayState extends State<UserPrivateLessonToday> {
  @override
  void initState() {
    print("init user private lesson today");
    super.initState();
  }

  @override
  void dispose() {
    print("dispose user private lesson today");
    super.dispose();
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
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserPrivateLesson()));
                }),
            title: Text("My lessons today: " + getNowDate()),
            backgroundColor: Color.fromRGBO(213, 21, 36, 1),
          ),
          body: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              // height: 220,
              width: double.maxFinite,
              color: Colors.white,
              child: FutureBuilder<List<PrivatelessonModel>>(
                  future: getPrivateLessonTodayFromWS(http.Client()),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PrivatelessonModel>> lessonSnapshot) {
                    List<Widget> children;
                    if (lessonSnapshot.hasData) {
                      return ListView.builder(
                        itemCount: lessonSnapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                              elevation: 5,
                              child: ListTile(
                                onTap: () {
                                  if (DateTime.parse(
                                          lessonSnapshot.data[index].day)
                                      .isBefore(DateTime.now())) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserReviewAdd(
                                            lessonSnapshot.data[index]),
                                      ),
                                    );
                                  }
                                },
                                leading: Container(
                                    padding: EdgeInsets.only(right: 12.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            right: new BorderSide(
                                                width: 1.0,
                                                color: Colors.black))),
                                    child: Icon(Icons.calendar_today)),
                                trailing: DateTime.parse(
                                            lessonSnapshot.data[index].day)
                                        .isBefore(DateTime.now())
                                    ? Icon(Icons.rate_review)
                                    : Icon(Icons.timelapse),
                                title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        lessonSnapshot.data[index].course_name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          lessonSnapshot.data[index]
                                                  .tutor[0]['firstname']
                                                  .toString()
                                                  .toUpperCase() +
                                              ' ' +
                                              lessonSnapshot.data[index]
                                                  .tutor[0]['lastname']
                                                  .toString()
                                                  .toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(DateFormat('EEEE').format(
                                              DateTime.parse(lessonSnapshot
                                                  .data[index].day)) +
                                          " | " +
                                          formatDate(DateTime.parse(
                                              lessonSnapshot.data[index].day))),
                                    ]),
                                subtitle: Text(
                                    lessonSnapshot.data[index].hour_from +
                                        ' - ' +
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
        ));
  }
}
