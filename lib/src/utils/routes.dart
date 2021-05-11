import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ism_app/src/screens/home/home.dart';
import 'package:ism_app/src/screens/login/login.dart';
import 'package:ism_app/src/screens/receipts/operation/detail_operation.dart';
import 'package:ism_app/src/screens/receipts/receipts.dart';
import 'package:ism_app/src/screens/splash_screen.dart';
import 'file:///C:/Users/Aakash-PC/Downloads/Projects/My/ISMApp/ism_app/lib/src/screens/receipts/details/receipt_details.dart';

class Routes {
  static const String strSplashScreenRoute = "splash_screen";
  static const String strLoginRoute = "login";
  static const String strHomeRoute = "home";
  static const String strReceiptsRoute = "receipts";
  static const String strReceiptDetailsRoute = "receipts_details";
  static const String strDetailOperationRoute = "details_operation";

  static appRoutes() {
    Map<String, WidgetBuilder> routes = HashMap();
    routes[Routes.strSplashScreenRoute] = (context) => SplashScreen();
    routes[Routes.strLoginRoute] = (context) => Login();
    routes[Routes.strHomeRoute] = (context) => Home();
    routes[Routes.strReceiptsRoute] = (context) => Receipts();
    routes[Routes.strReceiptDetailsRoute] = (context) => ReceiptDetails();
    routes[Routes.strDetailOperationRoute] = (context) => DetailOperations();
    return routes;
  }
}
