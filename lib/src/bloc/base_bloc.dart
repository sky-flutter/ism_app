import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ism_app/imports.dart';
import 'package:ism_app/src/screens/home/bloc/home_bloc.dart';
import 'package:ism_app/src/services/error_code.dart';

abstract class BaseBloc<E, S> extends Bloc<E, S> {
  HiveService hiveService = HiveService.instance;
  StreamSubscription<ConnectivityResult> subscription;
  ConnectivityResult result;
  List<Location> listLocationData;

  BaseBloc(S initialState) : super(initialState) {
    getCachedLocationData();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // this.result = result;
    });
  }

  Future<bool> isConnectionAvailable() async {
    var result = await Connectivity().checkConnectivity();
    return result != null && result != ConnectivityResult.none;
  }

  addDataToDatabase<T>(String boxName, List<T> data) async {
    await hiveService.clear(boxName);
    await hiveService.addBoxes<T>(data, boxName);
  }

  Future<List<Location>> getCachedLocationData() async {
    listLocationData = await HiveService.instance.getBoxes<Location>(HomeBloc.boxNameLocation);
    return listLocationData;
  }

  Location getSelectedLocation(String locationName) {
    locationName = locationName.toLowerCase();
    if (listLocationData != null) {
      try {
        var location = listLocationData.singleWhere((element) =>
            element.displayName.toString().toLowerCase() == locationName ||
            element.name.toString().toLowerCase() == locationName);
        return location;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Stream<BaseState> getCachedData<T>(String boxName) async* {
    try {
      var data = await hiveService.getBoxes<T>(boxName);
      if (data != null && data.isNotEmpty) {
        yield DataState<List<T>>(data);
      } else {
        yield ErrorState(errorCode: ErrorCode.NO_INTERNET_CONNECTION);
      }
    } catch (e) {
      yield ErrorState(errorCode: ErrorCode.REQUEST_CANCELLED);
    }
  }

  Future<List<T>> getCachedDataFuture<T>(String boxName) async {
    return await hiveService.getBoxes<T>(boxName);
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
