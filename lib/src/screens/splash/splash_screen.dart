import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ism_app/imports.dart';
import 'package:ism_app/src/screens/splash/bloc/splash_event.dart';
import 'package:ism_app/src/screens/splash/bloc/splash_state.dart';
import 'package:ism_app/src/utils/preference.dart';
import 'package:ism_app/src/widgets/loading/loader.dart';

import 'bloc/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashBloc _splashBloc;

  @override
  void initState() {
    super.initState();
    _splashBloc = SplashBloc();
    _splashBloc.add(SplashEvent());
  }

  moveToNext(String routeName) {
    Timer(Duration(seconds: 3), () {
      MyNavigator.pushReplacedNamed(routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) => _splashBloc,
      child: BlocListener<SplashBloc, BaseState>(
        listener: (BuildContext context, state) {
          if (state is AuthorizedState) {
            moveToNext(Routes.strHomeRoute);
          }
          if (state is UnAuthorizedState) {
            moveToNext(Routes.strLoginRoute);
          }
        },
        child: Scaffold(
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
                BlocBuilder<SplashBloc, BaseState>(builder: (context, state) {
                  if (state is LoadingState) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        child: Loader(),
                        margin: EdgeInsets.symmetric(vertical: 24),
                      ),
                    );
                  }
                  return Container();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
