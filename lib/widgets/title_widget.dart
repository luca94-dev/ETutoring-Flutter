import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final double fontSize;

  const TitleWidget({Key key, this.icon, this.text, this.color, this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // Icon(icon, size: 100),
          const SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(
                fontSize: this.fontSize,
                fontWeight: FontWeight.w400,
                color: this.color),
            textAlign: TextAlign.center,
          ),
        ],
      );
}
