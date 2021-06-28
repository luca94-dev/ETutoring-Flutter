import 'package:e_tutoring/constants/Theme.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StarOneWidget extends StatelessWidget {
  double star;
  bool pre = true;
  bool post = true;

  StarOneWidget({Key key, this.star, this.pre, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(tutorData.avg_reviews);

    final items = <Widget>[];
    if (star <= 0) {
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
        items.add(Text(" (" + star.toString() + "/5.0)",
            style: TextStyle(color: Colors.black)));

      var avgInteger = star.truncate();
      for (var i = 0; i < avgInteger; i = i + 1) {
        items.add(Icon(
          Icons.star,
          color: ArgonColors.redUnito,
        ));
        count += 1;
      }
      dynamic avgFraction = star - star.truncate();
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
          onTap: () {},
          child: Text(
            " (" + star.toString() + ")",
            style: TextStyle(color: Colors.black),
          )));
    return Row(children: items);
  }
}
