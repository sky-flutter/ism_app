import 'package:ism_app/imports.dart';
import 'package:ism_app/src/bloc/base_bloc.dart';
import 'package:ism_app/src/model/base_response.dart';
import 'package:ism_app/src/screens/login/bloc/login_event.dart';
import 'package:ism_app/src/screens/receipts/model/users_data.dart';
import 'package:ism_app/src/screens/receipts/receipts/model/receipt_data.dart';

class ReceiptsBloc extends BaseBloc<LoginEvent, BaseState> {
  final String boxName = "receipts";

  ReceiptsBloc() : super(UnInitiatedState());

  Future<ApiResponse> fetchUserData() async {
    try {
      var apiResponse = await apiClient.call(
          url: ApiConstant.ENDPOINT_USERS,
          params: {"page": 2},
          method: ApiMethod.GET);

      if (apiResponse is BaseResponse) {
        var listData = ReceiptResponse.fromJson(apiResponse.results);
        apiResponse.loadData(listData);
        return apiResponse;
      }
      return apiResponse as ErrorResponse;
    } catch (e) {
      throw Exception("Error");
    }
  }

  // Future<List<UserItemData>> getUserData() async {
  //   if (ConnectivityChecker.checkConnection(result)) {
  //     try {
  //       return (await fetchUserData()).listData;
  //     } catch (e) {
  //       throw Exception(e);
  //     }
  //   } else {
  //     return getCachedData();
  //   }
  // }

  Future<List<UserItemData>> getCachedData() async {
    var data = await hiveService.getBoxes<UserItemData>(boxName);
    if (data != null && data.isNotEmpty) {
      return Future.value(data);
    }
    return null;
  }

  // Stream<BaseState> getUserData1() async* {
  //   var data = await hiveService.getBoxes<UserItemData>(boxName);
  //   if (data != null && data.isNotEmpty) {
  //     yield DataState<List<UserItemData>>(data);
  //   } else {
  //     yield LoadingState();
  //     var usersData = await fetchUserData();
  //     yield getState(usersData);
  //   }
  // }

  getState(UsersData event) {
    if (event != null && event.listData != null && event.listData.isNotEmpty) {
      return DataState<List<UserItemData>>(event.listData);
    } else {
      return ErrorState();
    }
  }

  @override
  Stream<BaseState> mapEventToState(LoginEvent event) {}
}
