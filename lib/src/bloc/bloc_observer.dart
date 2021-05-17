import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ism_app/imports.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(Cubit cubit) {
    super.onCreate(cubit);
    apiClient.logger.i("Cubit Created :: $cubit");
  }

  @override
  void onChange(Cubit cubit, Change change) {
    super.onChange(cubit, change);
    apiClient.logger.i(
        "Cubit Changed :: $cubit CurrentState :: ${change.currentState} NextState:: ${change.nextState}");
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
    apiClient.logger.e("OnError :: $error");
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    apiClient.logger.i("OnEvent :: $bloc Event:: $event");
  }

  @override
  void onClose(Cubit cubit) {
    super.onClose(cubit);
    apiClient.logger.i("Cubit Closed :: $cubit");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    apiClient.logger.i(
        "onTransition :: $bloc Current State:: ${transition.currentState} NextState :: ${transition.nextState}");
  }
}
