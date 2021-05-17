import 'package:ism_app/imports.dart';
import 'package:ism_app/src/bloc/base_bloc.dart';
import 'package:ism_app/src/bloc/base_event.dart';
import 'package:ism_app/src/screens/splash/bloc/splash_event.dart';
import 'package:ism_app/src/screens/splash/bloc/splash_state.dart';
import 'package:ism_app/src/utils/preference.dart';

class SplashBloc extends BaseBloc<BaseEvent, BaseState> {
  SplashBloc() : super(UnInitiatedState());

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if(event is SplashEvent){
      yield* isUserAuthorized();
    }
  }

  Stream<BaseState> isUserAuthorized() async* {
    yield LoadingState();
    try {
      bool isLoggedIn =
          await MyPreference.get(ApiConstant.IS_LOGIN, SharePrefType.Bool);
      if (isLoggedIn!=null && isLoggedIn)
        yield AuthorizedState();
      else
        yield UnAuthorizedState();
    } catch (e) {
      print("ERROR :: $e");
    }
  }
}
