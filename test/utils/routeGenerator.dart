import 'package:e_tutoring/main.dart';
import 'package:e_tutoring/screens/calendar-student.dart';
import 'package:e_tutoring/screens/calendar-tutor.dart';
import 'package:e_tutoring/screens/change-password.dart';
import 'package:e_tutoring/screens/course.dart';
import 'package:e_tutoring/screens/login.dart';
import 'package:e_tutoring/screens/my-tutor-course.dart';
import 'package:e_tutoring/screens/my-tutor-lesson.dart';
import 'package:e_tutoring/screens/my-tutor-reviews.dart';
import 'package:e_tutoring/screens/my-tutor-timeslot.dart';
import 'package:e_tutoring/screens/privacy-policy.dart';
import 'package:e_tutoring/screens/profile.dart';
import 'package:e_tutoring/screens/review-user.dart';
import 'package:e_tutoring/screens/settings.dart';
import 'package:e_tutoring/screens/signup.dart';
import 'package:e_tutoring/screens/tutor.dart';
import 'package:e_tutoring/screens/tutorCourse.dart';
import 'package:e_tutoring/screens/tutorDetail.dart';
import 'package:e_tutoring/screens/user-private-lesson-today.dart';
import 'package:e_tutoring/screens/user-private-lesson.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyApp tests route', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    /*public route */
    expect(find.byType(Login), findsNothing);
    expect(find.byType(Signup), findsNothing);
    expect(find.byType(PrivacyPolicy), findsNothing);

    /*private route (after login) */
    /* STUDEN/TUTOR ROUTE */
    expect(find.byType(Profile), findsNothing);
    expect(find.byType(Changepassword), findsNothing);
    expect(find.byType(Settings), findsNothing);

    /* STUDENT ROUTE */
    expect(find.byType(Course), findsNothing);
    expect(find.byType(UserPrivateLesson), findsNothing);
    expect(find.byType(UserPrivateLesson), findsNothing);
    expect(find.byType(UserPrivateLessonToday), findsNothing);
    expect(find.byType(TutorDetail), findsNothing);
    expect(find.byType(Tutor), findsNothing);
    expect(find.byType(MyReviewUser), findsNothing);
    expect(find.byType(CalendarStudent), findsNothing);

    /* TUTOR ROUTE */
    expect(find.byType(MyTutorLesson), findsNothing);
    expect(find.byType(MyTutorCourse), findsNothing);
    expect(find.byType(TutorCourse), findsNothing);
    expect(find.byType(MyTutorTimeslot), findsNothing);
    expect(find.byType(MyTutorReviews), findsNothing);
    expect(find.byType(CalendarTutor), findsNothing);
  });
}
