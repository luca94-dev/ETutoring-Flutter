class CurriculumModel {
  // ignore: non_constant_identifier_names
  String degree_path_name;

  CurriculumModel(this.degree_path_name);

  CurriculumModel.fromJson(dynamic json) {
    degree_path_name = json['degree_path_name'] ?? '-';
  }

  toString() {
    return "degree_path_name = " + this.degree_path_name;
  }
}
