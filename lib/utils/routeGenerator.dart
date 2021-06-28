import 'package:e_tutoring/screens/calendar-student.dart';
import 'package:e_tutoring/screens/calendar-tutor.dart';
import 'package:e_tutoring/screens/course.dart';
import 'package:e_tutoring/screens/login.dart';
import 'package:e_tutoring/screens/my-tutor-course.dart';
import 'package:e_tutoring/screens/my-tutor-lesson.dart';
import 'package:e_tutoring/screens/my-tutor-reviews.dart';
import 'package:e_tutoring/screens/my-tutor-timeslot.dart';
import 'package:e_tutoring/screens/profile.dart';
import 'package:e_tutoring/screens/review-user.dart';
import 'package:e_tutoring/screens/settings.dart';
import 'package:e_tutoring/screens/tutor.dart';
import 'package:e_tutoring/screens/tutorCourse.dart';
import 'package:e_tutoring/screens/user-private-lesson.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // print(settings.name);
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile());
      case '/course':
        return MaterialPageRoute(builder: (_) => Course());
      case '/tutoring-course':
        return MaterialPageRoute(builder: (_) => TutorCourse());
      case '/calendar-tutor':
        return MaterialPageRoute(builder: (_) => CalendarTutor());
      case '/calendar-student':
        return MaterialPageRoute(builder: (_) => CalendarStudent());
      case '/settings':
        return MaterialPageRoute(builder: (_) => Settings());
      case '/tutor':
        return MaterialPageRoute(builder: (_) => Tutor());
      case '/tutor-course':
        return MaterialPageRoute(builder: (_) => TutorCourse());
      case '/my-tutor-course':
        return MaterialPageRoute(builder: (_) => MyTutorCourse());
      case '/my-tutor-timeslot':
        return MaterialPageRoute(builder: (_) => MyTutorTimeslot());
      case '/my-tutor-reviews':
        return MaterialPageRoute(builder: (_) => MyTutorReviews());
      case '/my-review-user':
        return MaterialPageRoute(builder: (_) => MyReviewUser());
      case '/private-lesson':
        return MaterialPageRoute(builder: (_) => UserPrivateLesson());
      case '/my-tutor-lesson':
        return MaterialPageRoute(builder: (_) => MyTutorLesson());

      default:
        // If there is no such named route in the switch statement, e.g. /unknown
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('E-tutoring'),
          backgroundColor: Color.fromRGBO(213, 21, 36, 1),
        ),
        body: Center(
          child: Text('Error Route'),
        ),
      );
    });
  }
}
