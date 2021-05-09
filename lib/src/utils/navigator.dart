import 'package:ism_app/main.dart';

class MyNavigator {
  static var navState = navigatorKey.currentState;

  static pushNamed(String name) {
    navState.pushNamed(name);
  }

  static pushReplacedNamed(String name) {
    navState.pushReplacementNamed(name);
  }
}
