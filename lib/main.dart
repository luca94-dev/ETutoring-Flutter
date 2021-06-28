import 'dart:async';

import 'package:e_tutoring/provider/locale_provider.dart';
import 'package:e_tutoring/screens/login.dart';
import 'package:e_tutoring/screens/profile.dart';
import 'package:e_tutoring/utils/routeGenerator.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/l10n.dart';

Future main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'E-Tutoring';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            home: MainPage(),
          );
        },
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget _body = CircularProgressIndicator();

  @override
  void initState() {
    super.initState();

    UserSecureStorage.getEmail().then((value) => (setState(() {
          // print(value);
          if (value != null)
            _body = Profile();
          else {
            _body = Login();
          }
        })));
  }

  @override
  void dispose() {
    super.dispose();
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
      home: _body,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
