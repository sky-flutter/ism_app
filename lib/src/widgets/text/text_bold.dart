import 'package:flutter/material.dart';
import 'package:ism_app/src/theme/style.dart';

class MyText extends StatelessWidget {
  final String text;
  double fontSize;
  Color color;
  TextAlign textAlign;
  FontWeight fontWeight;

  MyText(this.text,
      {this.fontSize = 16,
      this.color = Colors.black,
      this.textAlign = TextAlign.left,
      this.fontWeight = FontWeight.w400})
      : assert(text != null);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Style.normal.copyWith(
          fontSize: this.fontSize,
          color: this.color,
          fontWeight: this.fontWeight),
    );
  }
}
