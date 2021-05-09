import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ism_app/src/screens/home/home.dart';
import 'package:ism_app/src/screens/login/login.dart';
import 'package:ism_app/src/screens/splash_screen.dart';

class Routes {
  static const String strSplashScreenRoute = "splash_screen";
  static const String strLoginRoute = "login";
  static const String strHomeRoute = "login";

  static appRoutes() {
    Map<String, WidgetBuilder> routes = HashMap();
    routes[Routes.strSplashScreenRoute] = (context) => SplashScreen();
    routes[Routes.strLoginRoute] = (context) => Login();
    routes[Routes.strHomeRoute] = (context) => Home();
    return routes;
  }
}
