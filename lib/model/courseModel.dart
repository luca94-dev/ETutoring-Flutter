class CourseModel {
  // ignore: non_constant_identifier_names
  String course_id;
  // ignore: non_constant_identifier_names
  String course_name;
  // ignore: non_constant_identifier_names
  String course_cfu;
  // ignore: non_constant_identifier_names
  String enrollment_year;
  // ignore: non_constant_identifier_names
  String study_year;
  // ignore: non_constant_identifier_names
  String teaching_type;
  String dac;
  String department;
  String curriculum;
  String ssd;
  // ignore: non_constant_identifier_names
  String delivery_mode;
  String language;
  // ignore: non_constant_identifier_names
  String didactic_period;
  // ignore: non_constant_identifier_names
  String component_type;
  // ignore: non_constant_identifier_names
  String private_lesson_id;

  bool selected = false;

  CourseModel(
      this.course_id,
      this.course_name,
      this.course_cfu,
      this.enrollment_year,
      this.study_year,
      this.teaching_type,
      this.dac,
      this.department,
      this.curriculum,
      this.ssd,
      this.delivery_mode,
      this.language,
      this.didactic_period,
      this.component_type);

  CourseModel.fromJson(dynamic json) {
    course_id = json['course_id'] ?? '';
    course_name = json['course_name'] ?? '-';
    course_cfu = json['course_cfu'] ?? '-';
    enrollment_year = json['enrollment_year'] ?? '-';
    study_year = json['study_year'] ?? '-';
    teaching_type = json['teaching_type'] ?? '-';
    dac = json['dac'] ?? '';
    department = json['department'] ?? '-';
    curriculum = json['curriculum'] ?? '-';
    ssd = json['ssd'] ?? '-';
    delivery_mode = json['delivery_mode'] ?? '';
    language = json['language'] ?? '-';
    didactic_period = json['didactic_period'] ?? '-';
    component_type = json['component_type'] ?? '-';
  }

  toString() {
    return this.course_id + ", " + this.course_name;
  }
}
