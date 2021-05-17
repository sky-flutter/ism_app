import 'dart:async';

import 'package:ism_app/generated/l10n.dart';
import 'package:ism_app/main.dart';
import 'package:ism_app/src/bloc/base_bloc.dart';
import 'package:ism_app/src/bloc/base_state.dart';
import 'package:ism_app/src/model/base_response.dart';
import 'package:ism_app/src/screens/login/bloc/login_event.dart';
import 'package:ism_app/src/screens/receipts/model/users_data.dart';
import 'package:ism_app/src/services/api_client.dart';
import 'package:ism_app/src/services/db/hive_service.dart';
import 'package:ism_app/src/services/error_code.dart';
import 'package:ism_app/src/utils/error_handler.dart';

class DemoBloc extends BaseBloc<LoginEvent, BaseState> {
  HiveService hiveService = HiveService.instance;
  final String boxName = "receipt";

  DemoBloc() : super(UnInitiatedState());

  Future<ApiResponse> fetchUserData() async {
    ApiResponse response = await apiClient.call(
        url: "users", params: {"page": 2}, method: ApiMethod.GET);
    if (response is BaseResponse) {
      var usersData = UsersData.fromJson(response.data);
      await hiveService.clear(boxName);
      await hiveService.addBoxes(usersData.listData, boxName);
      response.loadData(usersData);
      return response;
    }
    return response;
  }

  Future<List<UserItemData>> getUserData() async {
    if (isConnectionAvailable()) {
      try {
        var apiResponse = await fetchUserData();
        if (apiResponse is BaseResponse) {
          return apiResponse.data as List<UserItemData>;
        } else {
          var response = apiResponse as ErrorResponse;
          throw Exception(response.errorMessage ??
              ErrorHandler.getErrorMessage(response.statusCode));
        }
      } catch (e) {
        throw Exception(S.current.error_apiError);
      }
    } else {
      List<UserItemData> listData = await getCachedData();
      if (listData != null) {
        return listData;
      } else {
        throw Exception(
            ErrorHandler.getErrorMessage(ErrorCode.NO_INTERNET_CONNECTION));
      }
    }
  }

  getCachedData() async {
    var data = await hiveService.getBoxes<UserItemData>(boxName);
    if (data != null && data.isNotEmpty) {
      return Future.value(data);
    }
    return Future.value(null);
  }

  Stream<BaseState> getUserData1() async* {
    var data = await hiveService.getBoxes<UserItemData>(boxName);
    if (data != null && data.isNotEmpty) {
      yield DataState<List<UserItemData>>(data);
    } else {
      yield LoadingState();
      var apiResponse = await fetchUserData();
      if (apiResponse is BaseResponse) {
        yield DataState<List<UserItemData>>(
            apiResponse.data as List<UserItemData>);
      } else {
        var response = apiResponse as ErrorResponse;
        yield ErrorState(
            errorMessage: response.errorMessage,
            errorCode: response.statusCode);
      }
    }
  }

  @override
  Stream<BaseState> mapEventToState(LoginEvent event) {}
}
