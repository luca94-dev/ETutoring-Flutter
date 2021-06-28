import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:flutter/material.dart';

import 'package:e_tutoring/constants/Theme.dart';

import 'package:e_tutoring/widgets/drawer-tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ArgonDrawer extends StatefulWidget {
  final String currentPage;
  const ArgonDrawer(this.currentPage);

  @override
  _ArgonDrawerState createState() => _ArgonDrawerState();
}

class _ArgonDrawerState extends State<ArgonDrawer> {
  // For CircularProgressIndicator.
  bool visible = false;

  @override
  initState() {
    super.initState();
    print("init drawer widget");
  }

  @override
  dispose() {
    print("dispose drawer widget");
    super.dispose();
  }

  Future wait() async {
    await new Future.delayed(const Duration(seconds: 5), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: ArgonColors.white,
      child: Column(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.85,
            child: SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: new Row(children: <Widget>[
                    Image.asset("assets/img/logo_size_1.jpg"),
                    Text("E-Tutoring")
                  ]),
                ),
              ),
            )),
        Expanded(
          flex: 2,
          child: ListView(
            padding: EdgeInsets.only(top: 24, left: 16, right: 16),
            children: [
              new FutureBuilder<String>(
                future: UserSecureStorage.getRole(),
                builder: (BuildContext context, AsyncSnapshot<String> role) {
                  switch (role.connectionState) {
                    case ConnectionState.none:
                      return new Text('Press button to start');
                    case ConnectionState.waiting:
                      return new Text('Awaiting result...');
                    default:
                      if (role.hasError)
                        return new Text('Error: ${role.error}');
                      else {
                        return Column(children: [
                          // ACL: ROLE = ALL
                          DrawerTile(
                              icon: Icons.person,
                              onTap: () {
                                if (widget.currentPage != "profile")
                                  Navigator.pushReplacementNamed(
                                      context, '/profile');
                              },
                              iconColor: ArgonColors.black,
                              title: AppLocalizations.of(context).profile,
                              isSelected: widget.currentPage == "profile"
                                  ? true
                                  : false),

                          role.data == "Tutor"
                              ? DrawerTile(
                                  icon: Icons.calendar_today,
                                  onTap: () {
                                    if (widget.currentPage != "my-tutor-lesson")
                                      Navigator.pushReplacementNamed(
                                          context, '/my-tutor-lesson');
                                  },
                                  iconColor: ArgonColors.black,
                                  title: AppLocalizations.of(context)
                                      .private_lesson,
                                  isSelected:
                                      widget.currentPage == "my-tutor-lesson"
                                          ? true
                                          : false)
                              : Container(),
                          // ACL: ROLE = Student ONLY STUDENT VIEW
                          role.data == "Student"
                              ? DrawerTile(
                                  icon: Icons.menu_book_rounded,
                                  onTap: () {
                                    if (widget.currentPage != "course")
                                      Navigator.pushReplacementNamed(
                                          context, '/course');
                                  },
                                  iconColor: ArgonColors.black,
                                  title: AppLocalizations.of(context).courses,
                                  isSelected: widget.currentPage == "course"
                                      ? true
                                      : false)
                              : Container(),
                          role.data == "Student"
                              ? DrawerTile(
                                  icon: Icons.calendar_today,
                                  onTap: () {
                                    if (widget.currentPage != "private-lesson")
                                      Navigator.pushReplacementNamed(
                                          context, '/private-lesson');
                                  },
                                  iconColor: ArgonColors.black,
                                  title: AppLocalizations.of(context)
                                      .private_lesson,
                                  isSelected:
                                      widget.currentPage == "private-lesson"
                                          ? true
                                          : false)
                              : Container(),
                          role.data == "Tutor"
                              ? Divider(
                                  thickness: 3,
                                  color: ArgonColors.redUnito,
                                )
                              : Container(),
                          role.data == "Tutor"
                              ? DrawerTile(
                                  icon: Icons.school,
                                  onTap: () {
                                    if (widget.currentPage != "my-tutor-course")
                                      Navigator.pushReplacementNamed(
                                          context, '/my-tutor-course');
                                  },
                                  iconColor: ArgonColors.black,
                                  title:
                                      AppLocalizations.of(context).my_courses,
                                  isSelected:
                                      widget.currentPage == "my-tutor-course"
                                          ? true
                                          : false)
                              : Container(),

                          role.data == "Tutor"
                              ? DrawerTile(
                                  icon: Icons.add,
                                  onTap: () {
                                    if (widget.currentPage != "tutor-course")
                                      Navigator.pushReplacementNamed(
                                          context, '/tutor-course');
                                  },
                                  iconColor: ArgonColors.black,
                                  title:
                                      AppLocalizations.of(context).add_courses,
                                  isSelected:
                                      widget.currentPage == "tutor-course"
                                          ? true
                                          : false)
                              : Container(),
                          role.data == "Tutor"
                              ? Divider(
                                  thickness: 3,
                                  color: ArgonColors.redUnito,
                                )
                              : Container(),
                          role.data == "Tutor"
                              ? DrawerTile(
                                  icon: Icons.timelapse,
                                  onTap: () {
                                    if (widget.currentPage !=
                                        "my-tutor-timeslot")
                                      Navigator.pushReplacementNamed(
                                          context, '/my-tutor-timeslot');
                                  },
                                  iconColor: ArgonColors.black,
                                  title:
                                      AppLocalizations.of(context).my_timeslot,
                                  isSelected:
                                      widget.currentPage == "my-tutor-timeslot"
                                          ? true
                                          : false)
                              : Container(),

                          role.data == "Tutor"
                              ? DrawerTile(
                                  icon: Icons.star,
                                  onTap: () {
                                    if (widget.currentPage !=
                                        "my-tutor-reviews")
                                      Navigator.pushReplacementNamed(
                                          context, "/my-tutor-reviews");
                                  },
                                  iconColor: ArgonColors.black,
                                  title: AppLocalizations.of(context)
                                      .reviews_about_me,
                                  isSelected:
                                      widget.currentPage == "my-tutor-reviews"
                                          ? true
                                          : false)
                              : Container(),
                          role.data == "Tutor"
                              ? Divider(
                                  thickness: 3,
                                  color: ArgonColors.redUnito,
                                )
                              : Container(),
                          // ACL: ROLE = Student ONLY STUDENT VIEW
                          role.data == "Student"
                              ? DrawerTile(
                                  icon: Icons.search,
                                  onTap: () {
                                    if (widget.currentPage != "tutor")
                                      Navigator.pushReplacementNamed(
                                          context, '/tutor');
                                  },
                                  iconColor: ArgonColors.black,
                                  title: AppLocalizations.of(context).tutor,
                                  isSelected: widget.currentPage == "tutor"
                                      ? true
                                      : false)
                              : Container(),

                          role.data == "Student"
                              ? Divider(
                                  thickness: 3,
                                  color: ArgonColors.redUnito,
                                )
                              : Container(),
                          role.data == "Student"
                              ? DrawerTile(
                                  icon: Icons.rate_review,
                                  onTap: () {
                                    if (widget.currentPage != "my-review-user")
                                      Navigator.pushReplacementNamed(
                                          context, '/my-review-user');
                                  },
                                  iconColor: ArgonColors.black,
                                  title:
                                      AppLocalizations.of(context).my_reviews,
                                  isSelected:
                                      widget.currentPage == "my-review-user"
                                          ? true
                                          : false)
                              : Container(),

                          // ACL: ROLE = ALL
                          /*DrawerTile(
                              icon: Icons.chat,
                              onTap: () {
                                if (widget.currentPage != "chat")
                                  Navigator.pushReplacementNamed(
                                      context, '/chat');
                              },
                              iconColor: ArgonColors.black,
                              title: AppLocalizations.of(context).chat,
                              isSelected:
                                  widget.currentPage == "chat" ? true : false),*/

                          role.data == "Tutor"
                              ? DrawerTile(
                                  icon: Icons.calendar_today,
                                  onTap: () {
                                    if (widget.currentPage != "calendar-tutor")
                                      Navigator.pushReplacementNamed(
                                          context, '/calendar-tutor');
                                  },
                                  iconColor: ArgonColors.black,
                                  title: AppLocalizations.of(context).calendar,
                                  isSelected:
                                      widget.currentPage == "calendar-tutor"
                                          ? true
                                          : false)
                              : Container(),
                          role.data == "Student"
                              ? DrawerTile(
                                  icon: Icons.calendar_today,
                                  onTap: () {
                                    if (widget.currentPage !=
                                        "calendar-student")
                                      Navigator.pushReplacementNamed(
                                          context, '/calendar-student');
                                  },
                                  iconColor: ArgonColors.black,
                                  title: AppLocalizations.of(context).calendar,
                                  isSelected:
                                      widget.currentPage == "calendar-student"
                                          ? true
                                          : false)
                              : Container(),
                          Divider(
                            thickness: 3,
                            color: ArgonColors.redUnito,
                          ),
                          // ACL: ROLE = ALL
                          DrawerTile(
                              icon: Icons.settings,
                              onTap: () {
                                if (widget.currentPage != "settings")
                                  Navigator.pushReplacementNamed(
                                      context, '/settings');
                              },
                              iconColor: ArgonColors.black,
                              title: AppLocalizations.of(context).settings,
                              isSelected: widget.currentPage == "settings"
                                  ? true
                                  : false),

                          // ACL: ROLE = ALL
                          /*DrawerTile(
                              icon: Icons.logout,
                              onTap: () async {
                                setState(() {
                                  visible = true;
                                });

                                await Future.delayed(
                                    const Duration(seconds: 1), () {});

                                // Delete email from secure storage
                                UserSecureStorage.delete('email');
                                // Delete password from secure storage
                                UserSecureStorage.delete('password');
                                // Delete role from secure storage
                                UserSecureStorage.delete('role');
                                Navigator.pop(context);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => Login(),
                                  ),
                                  (route) => false,
                                );
                              },
                              iconColor: ArgonColors.black,
                              title: AppLocalizations.of(context).logout,
                              isSelected: widget.currentPage == "Logout"
                                  ? true
                                  : false),*/
                        ]);
                      }
                  }
                },
              ),
              FutureBuilder(
                  future: wait(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default, show a loading spinner
                    return Visibility(
                        visible: visible,
                        child: Center(
                            child: CircularProgressIndicator(
                          backgroundColor: ArgonColors.redUnito,
                        )));
                  }),
            ],
          ),
        ),
      ]),
    ));
  }
}
