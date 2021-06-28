class TutorLessonModel {
  // ignore: non_constant_identifier_names
  String tutor_course_id;

  // ignore: non_constant_identifier_names
  String day;

  // ignore: non_constant_identifier_names
  String hour_from;

  // ignore: non_constant_identifier_names
  String hour_to;

  // ignore: non_constant_identifier_names
  String course_id;

  // ignore: non_constant_identifier_names
  String course_name;

  // ignore: non_constant_identifier_names
  String course_cfu;

  String department;

  dynamic student;

  TutorLessonModel(
      this.tutor_course_id,
      this.day,
      this.hour_from,
      this.hour_to,
      this.course_id,
      this.course_name,
      this.course_cfu,
      this.department,
      this.student);

  TutorLessonModel.fromJson(dynamic json) {
    tutor_course_id = json['tutor_course_id'] ?? '-';
    day = json['day'] ?? '-';
    hour_from = json['hour_from'] ?? '-';
    hour_to = json['hour_to'] ?? '-';
    course_id = json['course_id'] ?? '-';
    course_name = json['course_name'] ?? '-';
    course_cfu = json['course_cfu'] ?? '-';
    department = json['department'] ?? '-';
    student = json['student'] ?? '-';
  }

  toString() {
    return this.course_name +
        ", " +
        this.day +
        this.student[0]['firstname'] +
        this.student[0]['lastname'];
  }

  equals(TutorLessonModel lesson) {
    if (this.day == lesson.day &&
        this.tutor_course_id == lesson.tutor_course_id &&
        this.hour_from == lesson.hour_from &&
        this.hour_to == lesson.hour_to &&
        this.course_name == lesson.course_name)
      return true;
    else
      return false;
  }
}
