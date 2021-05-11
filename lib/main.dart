import 'package:flutter/material.dart';
import 'package:ism_app/src/theme/color.dart';
import 'package:ism_app/src/utils/routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: MyColors.colorPrimary,
      ),
      initialRoute: Routes.strReceiptDetailsRoute,
      routes: Routes.appRoutes(),
    );
  }
}
