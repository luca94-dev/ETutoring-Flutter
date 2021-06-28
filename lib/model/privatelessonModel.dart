class PrivatelessonModel {
// ignore: non_constant_identifier_names
  String private_lesson_id;
// ignore: non_constant_identifier_names
  String user_id;
// ignore: non_constant_identifier_names
  String tutor_course_id;
// ignore: non_constant_identifier_names
  String tutor_time_slot_id;
  String note;
  String id;
  String username;
  String password;
  String email;
// ignore: non_constant_identifier_names
  String created_at;
// ignore: non_constant_identifier_names
  String updated_at;
// ignore: non_constant_identifier_names
  String course_id;
  String day;
// ignore: non_constant_identifier_names
  String hour_from;
// ignore: non_constant_identifier_names
  String hour_to;
  String reserved;
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
// ignore: non_constant_identifier_names
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

  dynamic tutor;

  PrivatelessonModel(
      this.private_lesson_id,
      this.user_id,
      this.tutor_course_id,
      this.tutor_time_slot_id,
      this.note,
      this.id,
      this.username,
      this.password,
      this.email,
      this.created_at,
      this.updated_at,
      this.course_id,
      this.day,
      this.hour_from,
      this.hour_to,
      this.reserved,
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
      this.component_type,
      this.tutor);

  PrivatelessonModel.fromJson(dynamic json) {
    private_lesson_id = json['private_lesson_id'] ?? '-';
    user_id = json['user_id'] ?? '-';
    tutor_course_id = json['tutor_course_id'] ?? '-';
    tutor_time_slot_id = json['tutor_time_slot_id'] ?? '-';
    note = json['note'] ?? '-';
    id = json['id'] ?? '-';
    username = json['username'] ?? '-';
    password = json['password'] ?? '-';
    email = json['email'] ?? '-';
    created_at = json['created_at'] ?? '-';
    updated_at = json['updated_at'] ?? '-';
    course_id = json['course_id'] ?? '-';
    day = json['day'] ?? '-';
    hour_from = json['hour_from'] ?? '-';
    hour_to = json['hour_to'] ?? '-';
    reserved = json['reserved'] ?? '-';
    course_name = json['course_name'] ?? '-';
    course_cfu = json['course_cfu'] ?? '-';
    enrollment_year = json['enrollment_year'] ?? '-';
    study_year = json['study_year'] ?? '-';
    teaching_type = json['teaching_type'] ?? '-';
    dac = json['dac'] ?? '-';
    department = json['department'] ?? '-';
    curriculum = json['curriculum'] ?? '-';
    ssd = json['ssd'] ?? '-';
    delivery_mode = json['delivery_mode'] ?? '-';
    language = json['language'] ?? '-';
    didactic_period = json['didactic_period'] ?? '-';
    component_type = json['component_type'] ?? '-';
    tutor = json['tutor'] ?? [];
  }

  toString() {
    return this.course_name +
        this.day +
        this.tutor[0]['firstname'] +
        this.tutor[0]['lastname'];
  }
}
