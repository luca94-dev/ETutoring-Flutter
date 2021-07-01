import 'dart:async';

import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/controller/notification_controllerWS.dart';
import 'package:e_tutoring/controller/user_controllerWS.dart';
import 'package:e_tutoring/l10n/l10n.dart';
import 'package:e_tutoring/model/notificationTutorModel.dart';
import 'package:e_tutoring/model/userModel.dart';
import 'package:e_tutoring/provider/locale_provider.dart';
import 'package:e_tutoring/screens/change-password.dart';
import 'package:e_tutoring/screens/login.dart';
import 'package:e_tutoring/screens/profile-edit.dart';
import 'package:e_tutoring/utils/routeGenerator.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:e_tutoring/widgets/badge_icon.dart';
import 'package:e_tutoring/widgets/drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'package:move_to_background/move_to_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> firebaseCall() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String email;
  String password;

  // For CircularProgressIndicator.
  bool visible = false;

  StreamController<int> _countController = StreamController<int>();

  int _currentIndex = 0;
  int _tabBarCount = 0;

  List<Widget> _pages;

  Timer timer;

  List<NotificationsTutorModel> notificationsList = [];

  int badgeNotificationNumber = 0;

  void showNotification() {
    flutterLocalNotificationsPlugin.show(
        0,
        "E-Tutoring",
        AppLocalizations.of(context).message_notification,
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  @override
  void initState() {
    super.initState();
    print("init profile");

    firebaseCall();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });
      }
    });

    getNotificationsTutorFromWS(http.Client()).then((value) => {
          setState(() {
            notificationsList = value;

            for (var notification in notificationsList) {
              if (notification.check == "0") {
                badgeNotificationNumber++;
              }
            }
          })
        });

    // Future.delayed(const Duration(seconds: 5), () {});

    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      getNotificationsTutorFromWS(http.Client())
          .then((newNotificationsList) => {
                // print(newNotification),
                print(newNotificationsList.length),
                print(notificationsList.length),
                if (notificationsList.length >= 0 &&
                    notificationsList.length < newNotificationsList.length)
                  {
                    showNotification(),
                    setState(() {
                      notificationsList = newNotificationsList;
                      for (var notification in notificationsList) {
                        if (notification.check == "0") {
                          badgeNotificationNumber++;
                        }
                      }
                    })
                  }
              });
    });
  }

  @override
  void dispose() {
    print("dispose profile");
    _countController.close();
    notificationsList = [];
    timer.cancel();
    super.dispose();
  }

  Future init() async {
    final email = await UserSecureStorage.getEmail() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    this.email = email;
    this.password = password;
  }

  Widget build(BuildContext context) {
    _pages = [
      Stack(children: <Widget>[
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
                            color: Color.fromRGBO(205, 205, 205, 1),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 0.0, bottom: 20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        FutureBuilder<UserModel>(
                                          future:
                                              getUserInfoFromWS(http.Client()),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<UserModel> user) {
                                            List<Widget> children;
                                            if (user.hasData) {
                                              // print(user.data);
                                              children = <Widget>[
                                                new FutureBuilder<String>(
                                                    future: UserSecureStorage
                                                        .getRole(),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<String>
                                                            role) {
                                                      switch (role
                                                          .connectionState) {
                                                        case ConnectionState
                                                            .none:
                                                          return new Text(
                                                              'Press button to start');
                                                        case ConnectionState
                                                            .waiting:
                                                          /*return new Text(
                                                                            'Awaiting result...');*/
                                                          return new Text('');
                                                        default:
                                                          if (role.hasError)
                                                            return new Text(
                                                                'Error: ${role.error}');
                                                          else {
                                                            //print(role);                                                                              role);
                                                            return Column(
                                                                children: [
                                                                  Container(
                                                                      constraints: BoxConstraints(
                                                                          minWidth:
                                                                              600),
                                                                      color: Color.fromRGBO(
                                                                          205,
                                                                          205,
                                                                          205,
                                                                          1),
                                                                      child:
                                                                          DataTable(
                                                                        dataRowHeight:
                                                                            50,
                                                                        dataRowColor:
                                                                            MaterialStateColor.resolveWith((states) =>
                                                                                Colors.white),
                                                                        headingRowHeight:
                                                                            0,
                                                                        columns: <
                                                                            DataColumn>[
                                                                          DataColumn(
                                                                            label:
                                                                                Text(
                                                                              '',
                                                                            ),
                                                                          ),
                                                                          DataColumn(
                                                                            label:
                                                                                Text(
                                                                              '',
                                                                            ),
                                                                          ),
                                                                        ],
                                                                        rows: <
                                                                            DataRow>[
                                                                          DataRow(
                                                                            cells: <DataCell>[
                                                                              DataCell(Text(
                                                                                AppLocalizations.of(context).lastname,
                                                                                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15),
                                                                              )),
                                                                              DataCell(Text("${user.data.lastname}", style: TextStyle(fontSize: 15))),
                                                                            ],
                                                                          ),
                                                                          DataRow(
                                                                            cells: <DataCell>[
                                                                              DataCell(Text(AppLocalizations.of(context).name, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15))),
                                                                              DataCell(Text("${user.data.firstname}", style: TextStyle(fontSize: 15))),
                                                                            ],
                                                                          ),
                                                                          DataRow(
                                                                            cells: <DataCell>[
                                                                              DataCell(Text('Email', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15))),
                                                                              DataCell(
                                                                                Text(
                                                                                  "${user.data.email}",
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          DataRow(
                                                                            cells: <DataCell>[
                                                                              DataCell(Text('Password', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15))),
                                                                              DataCell(Row(children: <Widget>[
                                                                                Text("********", style: TextStyle(fontSize: 15)),
                                                                                TextButton(
                                                                                  style: ButtonStyle(
                                                                                    foregroundColor: MaterialStateProperty.all<Color>(ArgonColors.redUnito),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Changepassword()));
                                                                                  },
                                                                                  child: Text(AppLocalizations.of(context).change, style: TextStyle(fontSize: 15)),
                                                                                )
                                                                              ])),
                                                                            ],
                                                                          ),
                                                                          DataRow(
                                                                            cells: <DataCell>[
                                                                              DataCell(Text(
                                                                                AppLocalizations.of(context).phone_number,
                                                                                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                                                                              )),
                                                                              DataCell(Text("${user.data.phone_number}")),
                                                                            ],
                                                                          ),
                                                                          DataRow(
                                                                            cells: <DataCell>[
                                                                              DataCell(Text(
                                                                                AppLocalizations.of(context).nationality,
                                                                                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15),
                                                                              )),
                                                                              DataCell(Text("${user.data.nationality}", style: TextStyle(fontSize: 15))),
                                                                            ],
                                                                          ),
                                                                          DataRow(
                                                                            cells: <DataCell>[
                                                                              DataCell(Text(AppLocalizations.of(context).birth_place, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
                                                                              DataCell(Text("${user.data.birth_city}", style: TextStyle(fontSize: 15))),
                                                                            ],
                                                                          ),
                                                                          DataRow(
                                                                            cells: <DataCell>[
                                                                              DataCell(Text(AppLocalizations.of(context).residence_city, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
                                                                              DataCell(Text("${user.data.residence_city}", style: TextStyle(fontSize: 15))),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      )),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Container(
                                                                      constraints: BoxConstraints(
                                                                          minWidth:
                                                                              600),
                                                                      color: Color.fromRGBO(
                                                                          205,
                                                                          205,
                                                                          205,
                                                                          1),
                                                                      child:
                                                                          DataTable(
                                                                        dataRowHeight:
                                                                            60,
                                                                        dataRowColor:
                                                                            MaterialStateColor.resolveWith((states) =>
                                                                                Colors.white),
                                                                        headingRowHeight:
                                                                            0,
                                                                        columns: <
                                                                            DataColumn>[
                                                                          DataColumn(
                                                                            label:
                                                                                Text(
                                                                              '',
                                                                            ),
                                                                          ),
                                                                          DataColumn(
                                                                            label:
                                                                                Text(
                                                                              '',
                                                                            ),
                                                                          ),
                                                                        ],
                                                                        rows: <
                                                                            DataRow>[
                                                                          DataRow(
                                                                            cells: <DataCell>[
                                                                              DataCell(Text(AppLocalizations.of(context).role, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15))),
                                                                              DataCell(Text(user.data.role_name, style: TextStyle(fontSize: 15))),
                                                                            ],
                                                                          ),
                                                                          if (role.data ==
                                                                              "Student")
                                                                            DataRow(
                                                                              cells: <DataCell>[
                                                                                DataCell(Text(AppLocalizations.of(context).number, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15))),
                                                                                DataCell(Text("${user.data.badge_number}", style: TextStyle(fontSize: 15))),
                                                                              ],
                                                                            ),
                                                                          if (role.data ==
                                                                              "Student")
                                                                            DataRow(
                                                                              cells: <DataCell>[
                                                                                DataCell(Text(AppLocalizations.of(context).degree_course, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15))),
                                                                                DataCell(Text("${user.data.degree_name} (" + "${user.data.degree_athenaeum})", style: TextStyle(fontSize: 15))),
                                                                              ],
                                                                            ),
                                                                          if (role.data ==
                                                                              "Student")
                                                                            DataRow(
                                                                              cells: <DataCell>[
                                                                                DataCell(Text(AppLocalizations.of(context).type, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15))),
                                                                                DataCell(Text("${user.data.degree_type_note} (" + "${user.data.degree_type_name})", style: TextStyle(fontSize: 15))),
                                                                              ],
                                                                            ),
                                                                          if (role.data ==
                                                                              "Student")
                                                                            DataRow(
                                                                              cells: <DataCell>[
                                                                                DataCell(Text(AppLocalizations.of(context).headquarters, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15))),
                                                                                DataCell(Text("${user.data.degree_location}", style: TextStyle(fontSize: 15))),
                                                                              ],
                                                                            ),
                                                                          if (role.data ==
                                                                              "Student")
                                                                            DataRow(
                                                                              cells: <DataCell>[
                                                                                DataCell(Text(AppLocalizations.of(context).curriculum, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15))),
                                                                                DataCell(Text("${user.data.degree_path_name}", style: TextStyle(fontSize: 15))),
                                                                              ],
                                                                            ),
                                                                        ],
                                                                      )),
                                                                ]);
                                                          }
                                                      }
                                                    })
                                              ];
                                            } else if (user.hasError) {
                                              children = <Widget>[
                                                const Icon(
                                                  Icons.error_outline,
                                                  color: Colors.red,
                                                  size: 60,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15),
                                                  child: Text(
                                                      'Error: ${user.error}'),
                                                )
                                              ];
                                            } else {
                                              children = const <Widget>[
                                                SizedBox(
                                                  child:
                                                      CircularProgressIndicator(
                                                          backgroundColor:
                                                              ArgonColors
                                                                  .redUnito),
                                                  width: 60,
                                                  height: 60,
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 15),
                                                  child: Text(
                                                      'Awaiting result...',
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
      Container(
          child: Card(
              child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(child: child, opacity: animation);
                  },
                  child: ListView(
                      padding: new EdgeInsets.symmetric(vertical: 8.0),
                      children: _buildList().length == 0
                          ? [
                              const SizedBox(height: 30),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.image_search),
                                    Text(
                                        AppLocalizations.of(context)
                                            .notifications_not_found,
                                        style: TextStyle(fontSize: 18)),
                                  ])
                            ]
                          : _buildList())))),
    ];

    //this.init();
    return new WillPopScope(
        onWillPop: () async {
          MoveToBackground.moveTaskToBack();
          return false;
        },
        child: ChangeNotifierProvider(
            create: (context) => LocaleProvider(),
            builder: (context, child) {
              // Locale myLocale = Localizations.localeOf(context);
              // print(myLocale);
              final provider = Provider.of<LocaleProvider>(context);
              // print(provider.locale);

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
                    backgroundColor: Color.fromRGBO(205, 205, 205, 1),
                    appBar: AppBar(
                      title: Text(AppLocalizations.of(context).profile),
                      backgroundColor: Color.fromRGBO(213, 21, 36, 1),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            logout();
                          },
                          child: Text(
                            'Logout',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 17),
                          ),
                        ),
                        // IconButton(icon: Icon(Icons.logout), onPressed: () {}),
                      ],
                      //actions: <Widget>[]
                    ),

                    // Nav Bar (title: 'Profilo', bgColor: Color.fromRGBO(213, 21, 36, 1)),
                    drawer: ArgonDrawer("profile"),

                    body: _pages[_currentIndex],

                    bottomNavigationBar: _tabBar(),

                    floatingActionButton: new FloatingActionButton(
                      backgroundColor: ArgonColors.redUnito,
                      child: new Icon(Icons.edit),
                      onPressed: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileEdit()))
                      },
                    ),
                  ));
            }));
  }

  void logout() async {
    /*setState(() {
      visible = true;
    });*/

    await Future.delayed(const Duration(seconds: 1), () {});

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
  }

  Widget _tabBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 25),
          label: AppLocalizations.of(context).profile,
        ),
        BottomNavigationBarItem(
          icon: StreamBuilder(
            initialData: _tabBarCount,
            stream: _countController.stream,
            builder: (_, snapshot) => BadgeIcon(
              icon: Icon(
                Icons.notifications,
                size: 25,
              ),
              badgeCount: badgeNotificationNumber,
            ),
          ),
          label: AppLocalizations.of(context).notifications,
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) => setState(() {
        if (index == 1) {
          for (var notifications in notificationsList) {
            notificationsUpdateCheck(
                http.Client(), int.parse(notifications.notifications_tutor_id));
          }
        }
        _currentIndex = index;
      }),
    );
  }

  List<ChildItem> _buildList() {
    // print(lessonList);
    if (notificationsList != null) {
      return notificationsList
          .map((notification) => new ChildItem(notification))
          .take(8)
          .toList();
    } else
      return [];
  }
}

// ignore: must_be_immutable
class ChildItem extends StatefulWidget {
  dynamic lesson;

  ChildItem(lesson) {
    this.lesson = lesson;
  }

  @override
  ChildItemState createState() => new ChildItemState(this.lesson);
}

class ChildItemState extends State<ChildItem> {
  final NotificationsTutorModel notification;
  ChildItemState(this.notification);

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
          // selected: true,
          leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.black))),
              child: notification.check == "0"
                  ? Icon(Icons.notifications_active)
                  : Icon(Icons.notifications)),
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    notification.student[0]['firstname']
                            .toString()
                            .toUpperCase() +
                        ' ' +
                        notification.student[0]['lastname']
                            .toString()
                            .toUpperCase() +
                        AppLocalizations.of(context).has_booked_your_course +
                        notification.course_name +
                        AppLocalizations.of(context).for_the_date +
                        formatDate(DateTime.parse(notification.day)) +
                        " (" +
                        DateFormat('EEEE')
                            .format(DateTime.parse(notification.day)) +
                        ")",
                    style: notification.check == "0"
                        ? TextStyle(fontWeight: FontWeight.bold)
                        : TextStyle(fontWeight: FontWeight.normal)),
                /*Text(
              notification.course_name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
                notification.student[0]['firstname'].toString().toUpperCase() +
                    ' ' +
                    notification.student[0]['lastname']
                        .toString()
                        .toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(DateFormat('EEEE').format(DateTime.parse(notification.day)) +
                " | " +
                formatDate(DateTime.parse(notification.day))),*/
              ]),
          //subtitle: Text(notification.hour_from + " - " + notification.hour_to),
          selected: notification.check == "0" ? true : false,
          selectedTileColor:
              notification.check == "0" ? Colors.yellowAccent : Colors.white,
          /*trailing: notification.check == "0"
              ? Icon(Icons.fiber_new, color: Colors.green)
              : Icon(Icons.calendar_today),*/
        ));
  }
}
