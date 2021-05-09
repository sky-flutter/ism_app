import 'package:flutter/material.dart';
import 'package:ism_app/imports.dart';
import 'package:ism_app/src/widgets/text/text_bold.dart';

typedef OnPressListener = Function();

class MyButton extends StatelessWidget {
  final String text;
  double fontSize;
  Color textColor, buttonBgColor, outlineColor, shadowColor;
  FontWeight fontWeight;
  OnPressListener mPressListener;

  MyButton(this.text, this.mPressListener,
      {this.fontSize = 16,
      this.textColor = Colors.black,
      this.buttonBgColor = Colors.white,
      this.outlineColor = Colors.white,
      this.shadowColor = Colors.transparent,
      this.fontWeight = FontWeight.w400});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          mPressListener.call();
        },
        style: TextButton.styleFrom(
            backgroundColor: this.buttonBgColor,
            padding: EdgeInsets.only(bottom: 16, top: 16),
            shadowColor: this.shadowColor,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: this.outlineColor, width: 1),
                borderRadius: MyBorder.commonBorderRadius())),
        child: MyText(
          text,
          fontSize: this.fontSize,
          fontWeight: this.fontWeight,
          color: this.textColor,
        ));
  }
}
