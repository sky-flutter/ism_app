import 'dart:async';

import 'package:ism_app/imports.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      moveToNext();
    });
  }

  moveToNext() {
    Timer(Duration(seconds: 3), () {
      MyNavigator.pushReplacedNamed(Routes.strLoginRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color_FFFFFF,
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                Strings.splashLogo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
