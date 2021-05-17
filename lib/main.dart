import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:ism_app/imports.dart';
import 'package:ism_app/src/bloc/bloc_observer.dart';
import 'package:ism_app/src/notifier/app_language.dart';
import 'package:ism_app/src/screens/receipts/model/users_data.dart';
import 'package:ism_app/src/services/api_client.dart';
import 'package:ism_app/src/theme/color.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';

final navigatorKey = GlobalKey<NavigatorState>();
ApiClient apiClient = ApiClient.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  final appDirectory = await getApplicationDocumentsDirectory();
  apiClient.setUpClient();
  Bloc.observer = MyBlocObserver();
  Hive
    ..init(appDirectory.path)
    ..registerAdapter(UsersDataAdapter())
    ..registerAdapter(UserItemDataAdapter());
  runApp(MyApp(appLanguage: appLanguage));
}

class MyApp extends StatelessWidget {
  AppLanguage appLanguage;

  MyApp({this.appLanguage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppLanguage>(
            create: (context) => appLanguage,
          ),
        ],
        child: Consumer<AppLanguage>(builder: (context, model, widget) {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            locale: model.appLocale,
            theme: ThemeData(
              primarySwatch: MyColors.colorPrimary,
            ),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: S.delegate.supportedLocales,
            initialRoute: Routes.strSplashScreenRoute,
            routes: Routes.appRoutes(),
          );
        }));
  }
}
