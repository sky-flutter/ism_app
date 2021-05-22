import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ism_app/imports.dart';

var actualScreenWidth = window.physicalSize.width / window.devicePixelRatio;
var actualScreenHeight = window.physicalSize.height / window.devicePixelRatio;
var textScale = actualScreenWidth / (actualScreenWidth < 600 ? 414 : 600);

var isTablet = actualScreenWidth > 600;

parseDate(String date, {String format}) {
  var dateFormat = DateFormat(format ?? "yyyy-MM-dd hh:mm:ss");
  var dt = dateFormat.parse(date);
  var numberFormat = NumberFormat("00");
  return "${numberFormat.format(dt.day)}/${numberFormat.format(dt.month)}/${dt.year}";
}

parseTime(String date, {String format}) {
  var dateFormat = DateFormat(format ?? "yyyy-MM-dd hh:mm:ss");
  var dt = dateFormat.parse(date);
  var numberFormat = NumberFormat("00");
  return "${numberFormat.format(dt.hour)}:${numberFormat.format(dt.minute)}:${dt.second}";
}

showSnackBar(title, message, {color: Colors.red}) {
  Get.snackbar(title, message,
      borderRadius: 4,
      titleText: MyText(
        title,
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      messageText: MyText(
        message,
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      backgroundColor: color,
      colorText: Colors.white);
}

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
