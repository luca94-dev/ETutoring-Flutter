import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/controller/review_controller.dart';
import 'package:e_tutoring/l10n/l10n.dart';
import 'package:e_tutoring/model/reviewModel.dart';
import 'package:e_tutoring/provider/locale_provider.dart';
import 'package:e_tutoring/screens/courseDetail.dart';
import 'package:e_tutoring/utils/routeGenerator.dart';
import 'package:e_tutoring/widgets/drawer.dart';
import 'package:e_tutoring/widgets/star_one_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MyReviewUser extends StatefulWidget {
  @override
  MyReviewUserState createState() => new MyReviewUserState();
}

class MyReviewUserState extends State<MyReviewUser> {
  @override
  void initState() {
    super.initState();
    print("init my review user");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose my review user");
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
            title: Text(
                'My reviews'), // Text(AppLocalizations.of(context).my_reviews),
            backgroundColor: Color.fromRGBO(213, 21, 36, 1),
          ),
          drawer: ArgonDrawer("my-review-user"),
          body: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              // height: 220,
              width: double.maxFinite,
              color: Colors.white,
              child: FutureBuilder<List<ReviewModel>>(
                  future: getReviewsUserFromWS(http.Client()),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ReviewModel>> reviewsSnapshot) {
                    List<Widget> children;
                    if (reviewsSnapshot.hasData) {
                      return ListView.builder(
                        itemCount: reviewsSnapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                              elevation: 5,
                              child: ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.only(right: 12.0),
                                      decoration: new BoxDecoration(
                                          border: new Border(
                                              right: new BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black))),
                                      child: Icon(
                                        Icons.rate_review,
                                        color: Colors.green,
                                      )),
                                  title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          reviewsSnapshot
                                                  .data[index].firstname +
                                              " " +
                                              reviewsSnapshot
                                                  .data[index].lastname,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(reviewsSnapshot
                                            .data[index].review_comment)
                                      ]),
                                  subtitle: StarOneWidget(
                                      star: double.parse(reviewsSnapshot
                                          .data[index].review_star),
                                      pre: false,
                                      post: false)));
                        },
                      );
                    } else if (reviewsSnapshot.hasError) {
                      children = <Widget>[
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text('Error: ${reviewsSnapshot.error}'),
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
