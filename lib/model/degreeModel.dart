class DegreeModel {
  // ignore: non_constant_identifier_names
  String degree_id;
  // ignore: non_constant_identifier_names
  String degree_name;
  // ignore: non_constant_identifier_names
  String degree_type_name;
// ignore: non_constant_identifier_names
  String degree_type_note;

  DegreeModel(this.degree_id, this.degree_name, this.degree_type_name,
      this.degree_type_note);

  DegreeModel.fromJson(dynamic json) {
    degree_id = json['degree_id'] ?? '-';
    degree_name = json['degree_name'] ?? '-';
    degree_type_name = json['degree_type_name'] ?? '-';
    degree_type_note = json['degree_type_note'] ?? '-';
  }

  toString() {
    return "degree_id = " +
        this.degree_id +
        ", degree_name = " +
        this.degree_name;
  }
}
