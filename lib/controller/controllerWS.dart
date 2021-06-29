import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/model/notificationTutorModel.dart';
import 'package:e_tutoring/model/privatelessonModel.dart';
import 'package:e_tutoring/model/roleModel.dart';
import 'package:e_tutoring/model/courseModel.dart';
import 'package:e_tutoring/model/curriculumModel.dart';
import 'package:e_tutoring/model/degreeModel.dart';
import 'package:e_tutoring/model/reviewModel.dart';
import 'package:e_tutoring/model/tutorLesson.dart';
import 'package:e_tutoring/model/tutorModel.dart';
import 'package:e_tutoring/model/userModel.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<UserModel> getUserInfoFromWS(http.Client client) async {
  try {
    var queryParameters = {
      'email': await UserSecureStorage.getEmail(),
    };
    // print(queryParameters);
    var response = await client.get(
        Uri.https(authority, unencodedPath + "users_list.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    var user;
    if (response.statusCode == 200) {
      // print(response.body);
      var userJsonData = json.decode(response.body);
      user = UserModel.fromJson(userJsonData);
      // print(user);
    }
    return user;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<List<CourseModel>> getUserCourseSearchFromWS(http.Client client,
    {String searchString = '', String email = ''}) async {
  List<CourseModel> courseList = [];
  var queryParameters;
  try {
    if (email.isEmpty || email == null) {
      queryParameters = {
        'email': await UserSecureStorage.getEmail(),
      };

      if (searchString != '') {
        queryParameters = {
          'email': await UserSecureStorage.getEmail(),
          'query': searchString,
        };
      }
    } else {
      queryParameters = {
        'email': email,
      };

      if (searchString != '') {
        queryParameters = {
          'email': email,
          'query': searchString,
        };
      }
    }
    // print(queryParameters);

    var response = await client.get(
        Uri.https(
            authority, unencodedPath + "course_search.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});
    if (response.statusCode == 200) {
      // print(response.body);
      var courseJsonData = json.decode(response.body);
      // print(courseJsonData);
      for (var courseItem in courseJsonData) {
        var course = CourseModel.fromJson(courseItem);
        // print(course);
        courseList.add(course);
      }
    }
    return courseList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return [];
  }
}

Future<List<CourseModel>> getAllCourseFromWS(http.Client client) async {
  List<CourseModel> courseList = [];

  try {
    var response = await client.get(
        Uri.https(authority, unencodedPath + "course_list.php"),
        headers: <String, String>{'authorization': basicAuth});
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var courseJsonData = json.decode(response.body);
      for (var courseItem in courseJsonData) {
        var course = CourseModel.fromJson(courseItem);
        courseList.add(course);
      }
    }
    return courseList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return [];
  }
}

Future<List<DegreeModel>> getDegreeListFromWS(http.Client client) async {
  List<DegreeModel> degreeList = [];

  try {
    var response = await client.get(
      Uri.https(authority, unencodedPath + "degree_list.php"),
      headers: <String, String>{'authorization': basicAuth},
    );
    if (response.statusCode == 200) {
      var degreeJsonData = json.decode(response.body);
      for (var degreeItem in degreeJsonData) {
        var degree = DegreeModel.fromJson(degreeItem);
        degreeList.add(degree);
      }
    }
    return degreeList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return [];
  }
}

Future<List<CurriculumModel>> getCurriculumListFromWS(
    http.Client client, String degreeName, String degreeTypeName) async {
  List<CurriculumModel> curriculumList = [];

  //https://www.e-tutoring-app.it/ws/curriculum_path_by_degree.php?degree_name=informatica&degree_type_note=LaureaTriennale
  var queryParameters = {
    'degree_name': degreeName,
    'degree_type_note': degreeTypeName
  };
  try {
    var response = await client.get(
        Uri.https(authority, unencodedPath + "curriculum_path_by_degree.php",
            queryParameters),
        headers: <String, String>{'authorization': basicAuth});
    if (response.statusCode == 200) {
      var curriculumJsonData = json.decode(response.body);
      for (var curriculumItem in curriculumJsonData) {
        var curriculum = CurriculumModel.fromJson(curriculumItem);
        curriculumList.add(curriculum);
      }
    }
    return curriculumList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return [];
  }
}

Future<List<RoleModel>> getRoleListFromWS(http.Client client) async {
  List<RoleModel> roleList = [];

  try {
    var response = await client.get(
        Uri.https(authority, unencodedPath + "role_list.php"),
        headers: <String, String>{'authorization': basicAuth});
    if (response.statusCode == 200) {
      var roleJsonData = json.decode(response.body);
      for (var roleItem in roleJsonData) {
        var role = RoleModel.fromJson(roleItem);
        roleList.add(role);
      }
    }
    return roleList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return [];
  }
}

Future<CourseModel> getCourseDetailFromWS(
    http.Client client, String courseId) async {
  try {
    var queryParameters = {
      'course_id': courseId,
    };
    // print(queryParameters);
    var response = await client.get(
        Uri.https(
            authority, unencodedPath + "course_list.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    var course;
    if (response.statusCode == 200) {
      // print(response.body);
      var courseJsonData = json.decode(response.body);
      course = CourseModel.fromJson(courseJsonData);
      // print(user);
    }
    return course;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<List<TutorModel>> getTutorSearchFromWS(http.Client client) async {
  List<TutorModel> tutorList = [];
  try {
    var response = await client.get(
        Uri.https(authority, unencodedPath + "tutor_list.php"),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      // print(response.body);
      var tutorJsonData = json.decode(response.body);
      //  print(tutorJsonData);
      for (var item in tutorJsonData) {
        // print(item['id']);
        var tutorItem = TutorModel.fromJson(item);
        tutorList.add(tutorItem);
      }
      // print(tutorList);
    }
    return tutorList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<TutorModel> getTutorDetailFromWS(http.Client client,
    {String email}) async {
  try {
    var queryParameters;
    if (email == null) {
      queryParameters = {
        'email': await UserSecureStorage.getEmail(),
      };
    } else {
      queryParameters = {
        'email': email,
      };
    }
    var tutorItem;
    var response = await client.get(
        Uri.https(authority, unencodedPath + "tutor_list.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var tutorJsonData = json.decode(response.body);
      tutorItem = TutorModel.fromJson(tutorJsonData);
    }
    return tutorItem;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<List<ReviewModel>> getReviewFromWS(
    http.Client client, String userTutorId) async {
  List<ReviewModel> reviewList = [];
  try {
    var queryParameters = {
      'user_tutor_id': userTutorId,
    };
    // print(queryParameters);
    var response = await client.get(
        Uri.https(
            authority, unencodedPath + "reviews_list.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var reviewJsonData = json.decode(response.body);
      for (var item in reviewJsonData) {
        // print(item['id']);
        var reviewItem = ReviewModel.fromJson(item);
        reviewList.add(reviewItem);
      }
    }
    return reviewList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<List<ReviewModel>> getReviewTutorFromWS(http.Client client) async {
  List<ReviewModel> reviewList = [];
  try {
    var queryParameters = {
      'email': await UserSecureStorage.getEmail(),
    };
    // print(queryParameters);
    var response = await client.get(
        Uri.https(
            authority, unencodedPath + "reviews_tutor.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var reviewJsonData = json.decode(response.body);
      for (var item in reviewJsonData) {
        var reviewItem = ReviewModel.fromJson(item);
        reviewList.add(reviewItem);
      }
    }
    return reviewList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<List<ReviewModel>> getReviewsUserFromWS(http.Client client) async {
  List<ReviewModel> reviewList = [];
  try {
    var queryParameters = {
      'email': await UserSecureStorage.getEmail(),
    };
    // print(queryParameters);
    var response = await client.get(
        Uri.https(
            authority, unencodedPath + "reviews_user.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var reviewJsonData = json.decode(response.body);
      for (var item in reviewJsonData) {
        var reviewItem = ReviewModel.fromJson(item);
        reviewList.add(reviewItem);
      }
    }
    return reviewList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<RoleModel> getRoleFromWS(http.Client client, String email) async {
  try {
    var queryParameters = {
      'email': email,
    };
    // print(queryParameters);
    var response = await client.get(
        Uri.https(
            authority, unencodedPath + "get_user_role.php", queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    var course;
    if (response.statusCode == 200) {
      // print(response.body);
      var courseJsonData = json.decode(response.body);
      course = RoleModel.fromJson(courseJsonData);
    }
    return course;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<List<PrivatelessonModel>> getPrivateLessonFromWS(
    http.Client client) async {
  try {
    List<PrivatelessonModel> lessonList = [];
    var queryParameters = {
      'email': await UserSecureStorage.getEmail(),
    };
    // print(queryParameters);
    var response = await client.get(
        Uri.https(authority, unencodedPath + "private_lesson_list.php",
            queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var lessonJsonData = json.decode(response.body);
      for (var item in lessonJsonData) {
        var lessonItem = PrivatelessonModel.fromJson(item);
        lessonList.add(lessonItem);
      }
    }
    return lessonList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<List<TutorLessonModel>> getTutorLessonFromWS(http.Client client) async {
  List<TutorLessonModel> lessonList = [];
  try {
    var queryParameters = {
      'email': await UserSecureStorage.getEmail(),
    };

    var response = await client.get(
        Uri.https(authority, unencodedPath + "tutor_lesson_list.php",
            queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      // print(response.body);
      var lessonJsonData = json.decode(response.body);
      //  print(tutorJsonData);
      for (var lesson in lessonJsonData) {
        // print(item['id']);
        var tutorItem = TutorLessonModel.fromJson(lesson);
        lessonList.add(tutorItem);
      }
      // print(tutorList);
    }
    return lessonList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<List<TutorLessonModel>> getTutorLessonTodayFromWS(
    http.Client client) async {
  List<TutorLessonModel> lessonList = [];
  try {
    var queryParameters = {
      'email': await UserSecureStorage.getEmail(),
    };

    var response = await client.get(
        Uri.https(authority, unencodedPath + "tutor_lesson_today_list.php",
            queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      // print(response.body);
      var lessonJsonData = json.decode(response.body);
      //  print(tutorJsonData);
      for (var lesson in lessonJsonData) {
        // print(item['id']);
        var tutorItem = TutorLessonModel.fromJson(lesson);
        lessonList.add(tutorItem);
      }
      // print(tutorList);
    }
    return lessonList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<List<NotificationsTutorModel>> getNotificationsTutorFromWS(
    http.Client client) async {
  List<NotificationsTutorModel> notificationsList = [];
  try {
    var queryParameters = {
      'email': await UserSecureStorage.getEmail(),
    };

    var response = await client.get(
        Uri.https(authority, unencodedPath + "notifications_tutor.php",
            queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      // print(response.body);
      var notificationsJsonData = json.decode(response.body);
      for (var notification in notificationsJsonData) {
        var notificationItem = NotificationsTutorModel.fromJson(notification);
        notificationsList.add(notificationItem);
      }
    }
    return notificationsList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return [];
  }
}

Future<bool> notificationsUpdateCheck(int notificationsTutorId) async {
  try {
    var data = {
      'notifications_tutor_id': notificationsTutorId,
    };
    var response = await http
        .post(
            Uri.https(
                authority, unencodedPath + 'notifications_tutor_check.php'),
            headers: <String, String>{'authorization': basicAuth},
            body: json.encode(data))
        .timeout(const Duration(seconds: 8));
    // print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<List<PrivatelessonModel>> getPrivateLessonTodayFromWS(
    http.Client client) async {
  try {
    List<PrivatelessonModel> lessonList = [];
    var queryParameters = {
      'email': await UserSecureStorage.getEmail(),
    };
    // print(queryParameters);
    var response = await client.get(
        Uri.https(authority, unencodedPath + "private_lesson_today_list.php",
            queryParameters),
        headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var lessonJsonData = json.decode(response.body);
      for (var item in lessonJsonData) {
        var lessonItem = PrivatelessonModel.fromJson(item);
        lessonList.add(lessonItem);
      }
    }
    return lessonList;
  } on Exception catch ($e) {
    print('error caught: ' + $e.toString());
    return null;
  }
}

Future<bool> login(http.Client client, String email, String password) async {
  var data = {'email': email, 'password': password};
  // Starting Web API Call.
  // https method: POST
  var response = await http
      .post(Uri.https(authority, unencodedPath + 'user_login.php'),
          headers: <String, String>{'authorization': basicAuth},
          body: json.encode(data))
      .timeout(const Duration(seconds: 8));
  if (response.statusCode == 200) {
    var message = jsonDecode(response.body);

    // If the Response Message is Matched.
    if (message == 'Login Matched') {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
