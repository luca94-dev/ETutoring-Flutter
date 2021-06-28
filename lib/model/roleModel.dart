class RoleModel {
  // ignore: non_constant_identifier_names
  String role_id;
  // ignore: non_constant_identifier_names
  String role_name;
  // ignore: non_constant_identifier_names
  String role_description;

  RoleModel(this.role_id, this.role_name, this.role_description);

  RoleModel.fromJson(dynamic json) {
    role_id = json['role_id'] ?? '-';
    role_name = json['role_name'] ?? '-';
    role_description = json['role_description'] ?? '-';
  }

  toString() {
    return "role_name = " + this.role_name;
  }
}
