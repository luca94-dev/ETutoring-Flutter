import 'package:e_tutoring/constants/Theme.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StarWidget extends StatelessWidget {
  final dynamic tutorData;
  bool pre = true;
  bool post = true;

  StarWidget({Key key, this.tutorData, this.pre, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(tutorData.avg_reviews);

    final items = <Widget>[];
    if (tutorData.avg_reviews <= 0) {
      // no reviews
      for (var i = 0; i < 5; i += 1) {
        items.add(Icon(
          Icons.star_border_outlined,
          color: ArgonColors.redUnito,
        ));
      }
    } else {
      int count = 0;
      // reviews > 0
      if (this.pre)
        items.add(Text(" (" + tutorData.avg_reviews.toString() + "/5.0)",
            style: TextStyle(color: Colors.black)));

      var avgInteger = tutorData.avg_reviews.truncate();
      for (var i = 0; i < avgInteger; i = i + 1) {
        items.add(Icon(
          Icons.star,
          color: ArgonColors.redUnito,
        ));
        count += 1;
      }
      dynamic avgFraction =
          tutorData.avg_reviews - tutorData.avg_reviews.truncate();
      if (avgFraction >= 0.5) {
        items.add(Icon(
          Icons.star_half_outlined,
          color: ArgonColors.redUnito,
        ));
        count += 1;
      }

      if (count < 5) {
        for (var i = 0; i < (5 - count); i = i + 1) {
          items.add(Icon(
            Icons.star_border_outlined,
            color: ArgonColors.redUnito,
          ));
        }
      }
    }

    if (this.post)
      items.add(new GestureDetector(
          onTap: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Review()),
            );*/
          },
          child: Text(
            " (" + tutorData.reviews.length.toString() + ")",
            style: TextStyle(color: Colors.black),
          )));
    return Row(children: items);
  }
}
