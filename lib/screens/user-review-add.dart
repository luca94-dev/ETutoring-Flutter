import 'dart:convert';

import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/screens/review-user.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'package:e_tutoring/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class UserReviewAdd extends StatefulWidget {
  var lessonData;

  UserReviewAdd(this.lessonData);
  @override
  UserReviewAddState createState() => new UserReviewAddState(lessonData);
}

class UserReviewAddState extends State<UserReviewAdd> {
  var lessonData;
  UserReviewAddState(this.lessonData);

  final formKey = GlobalKey<FormState>();

  final commentReview = TextEditingController();
  final starReview = TextEditingController();

  @override
  void initState() {
    super.initState();
    // print(this.lessonData);
  }

// CONTROLLER
  Future addReview() async {
    try {
      String email = await UserSecureStorage.getEmail();

      var data = {
        'email': email,
        'user_tutor_id': this.lessonData.tutor[0]["user_id"],
        'review_star': this.starReview.text,
        'review_comment': this.commentReview.text,
      };
      //print(data);

      var response = await http
          .post(Uri.https(authority, unencodedPath + 'add_user_review.php'),
              headers: <String, String>{'authorization': basicAuth},
              body: json.encode(data))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        var message = jsonDecode(response.body);
        // print(response.body);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(message),
              actions: <Widget>[
                TextButton(
                  child: new Text(
                    "OK",
                    style: TextStyle(color: ArgonColors.redUnito),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new MyReviewUser()));
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Error adding review"),
              actions: <Widget>[
                TextButton(
                  child: new Text(
                    "OK",
                    style: TextStyle(color: ArgonColors.redUnito),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error adding review. Verify Your Connection.'),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).add_review +
              " " +
              this.lessonData.tutor[0]['firstname'] +
              " " +
              this.lessonData.tutor[0]['lastname']),
          backgroundColor: Color.fromRGBO(213, 21, 36, 1),
          actions: <Widget>[],
        ),
        body: Stack(children: [
          Container(
              decoration:
                  BoxDecoration(color: Color.fromRGBO(205, 205, 205, 1))),
          SafeArea(
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Form(
                      key: formKey,
                      child: ListView(padding: EdgeInsets.all(8), children: [
                        const SizedBox(height: 20),
                        Text(AppLocalizations.of(context).write_a_review,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a review text.';
                            }
                            return null;
                          },
                          controller: commentReview,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            hintText:
                                AppLocalizations.of(context).write_a_review,
                            prefixIcon: Icon(Icons.edit),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(AppLocalizations.of(context).score,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a score.';
                            }
                            final number = num.tryParse(value);

                            if (number == null) {
                              return 'Please enter a valid score (1-5).';
                            }
                            if (number < 1 || number > 5) {
                              return 'Please enter a valid score (1-5).';
                            }
                            return null;
                          },
                          controller: starReview,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            hintText: AppLocalizations.of(context).score,
                            prefixIcon: Icon(Icons.score),
                            /*suffixIcon: GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.score,
                                color: Colors.black,
                              ),
                            ),*/
                          ),
                        ),
                        const SizedBox(height: 50),
                        buildSaveButton()
                      ]))))
        ]));
  }

  Widget buildSaveButton() => ButtonWidget(
      pressed: true,
      text: AppLocalizations.of(context).save,
      color: ArgonColors.redUnito,
      onClicked: () {
        if (formKey.currentState.validate()) {
          addReview();
        }
      });
}
