import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ism_app/imports.dart';

abstract class BaseBloc<E, S> extends Bloc<E, S> {
  HiveService hiveService = HiveService.instance;
  StreamSubscription<ConnectivityResult> subscription;
  ConnectivityResult result;

  BaseBloc(S initialState) : super(initialState) {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      this.result = result;
    });
  }

  bool isConnectionAvailable() {
    return result != ConnectivityResult.none;
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
