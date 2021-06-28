class TutorTimeslotModel {
  // ignore: non_constant_identifier_names
  String tutor_time_slot_id;
  // ignore: non_constant_identifier_names
  String course_id;
  String day;
  // ignore: non_constant_identifier_names
  String hour_from;
  // ignore: non_constant_identifier_names
  String hour_to;
  // ignore: non_constant_identifier_names
  String user_id;

  String reserved;
  // ignore: non_constant_identifier_names
  String course_name;

  bool selected = false;

  TutorTimeslotModel(
      this.tutor_time_slot_id,
      this.course_id,
      this.day,
      this.hour_from,
      this.hour_to,
      this.reserved,
      this.user_id,
      this.course_name);

  TutorTimeslotModel.fromJson(dynamic json) {
    tutor_time_slot_id = json['tutor_time_slot_id'] ?? '';
    course_id = json['course_id'] ?? '-';
    day = json['day'] ?? '-';
    hour_from = json['hour_from'] ?? '-';
    hour_to = json['hour_to'] ?? '-';
    reserved = json['reserved'] ?? '-';
    user_id = json['user_id'] ?? '-';
    course_name = json['course_name'] ?? "-";
  }

  toString() {
    return this.day + ", " + this.hour_from + ", " + this.hour_to;
  }
}
