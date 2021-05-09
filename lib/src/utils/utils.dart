import 'dart:ui';

import 'package:flutter/material.dart';

var actualScreenWidth = window.physicalSize.width / window.devicePixelRatio;
var actualScreenHeight = window.physicalSize.height / window.devicePixelRatio;
var textScale = actualScreenWidth / (actualScreenWidth < 600 ? 414 : 600);

var isTablet = actualScreenWidth > 600;

double rWidth(double percentage) {
  return actualScreenWidth * (percentage / 100);
}

double rHeight(double percentage) {
  return actualScreenHeight * (percentage / 100);
}

checkNullString(String str) {
  return str != null && str != '' ? str : '';
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}