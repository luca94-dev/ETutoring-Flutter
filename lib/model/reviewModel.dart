class ReviewModel {
  // ignore: non_constant_identifier_names
  String review_id;
  // ignore: non_constant_identifier_names
  String user_tutor_id;
  // ignore: non_constant_identifier_names
  String user_id;
  // ignore: non_constant_identifier_names
  String review_star;
  // ignore: non_constant_identifier_names
  String review_comment;
  String email;
  String username;
  String firstname;
  String lastname;

  ReviewModel(this.review_id, this.user_tutor_id, this.user_id,
      this.review_star, this.review_comment, this.email, this.username);

  ReviewModel.fromJson(dynamic json) {
    review_id = json['review_id'] ?? '-';
    user_tutor_id = json['user_tutor_id'] ?? '-';
    user_id = json['user_id'] ?? '-';
    review_star = json['review_star'] ?? '-';
    review_comment = json['review_comment'] ?? '-';
    email = json['email'] ?? '-';
    username = json['username'] ?? '-';
    firstname = json['firstname'] ?? '-';
    lastname = json['lastname'] ?? '-';
  }

  toString() {
    return "review_id = " +
        this.review_id +
        "\nreview_comment = " +
        this.review_comment;
  }
}
