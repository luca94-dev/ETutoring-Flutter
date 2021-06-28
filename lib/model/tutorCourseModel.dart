class TutorCourseModel {
  // ignore: non_constant_identifier_names
  String tutor_course_id;
  // ignore: non_constant_identifier_names
  String note;
  // ignore: non_constant_identifier_names
  String user_id;
  // ignore: non_constant_identifier_names
  String course_id;
  // ignore: non_constant_identifier_names
  String course_name;

  String department;

  bool selected = false;

  TutorCourseModel(this.tutor_course_id, this.note, this.user_id,
      this.course_id, this.course_name, this.department);

  TutorCourseModel.fromJson(dynamic json) {
    tutor_course_id = json['tutor_course_id'] ?? '';
    note = json['note'] ?? '-';
    user_id = json['user_id'] ?? '-';
    course_id = json['course_id'] ?? '-';
    course_name = json['course_name'] ?? '-';
    department = json['department'] ?? '-';
  }

  toString() {
    return this.tutor_course_id + ", " + this.user_id + ", " + this.course_id;
  }
}
