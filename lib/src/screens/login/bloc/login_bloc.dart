import 'dart:collection';

import 'package:ism_app/imports.dart';
import 'package:ism_app/main.dart';
import 'package:ism_app/src/bloc/base_bloc.dart';
import 'package:ism_app/src/bloc/base_state.dart';
import 'package:ism_app/src/model/base_response.dart';
import 'package:ism_app/src/screens/login/bloc/login_event.dart';
import 'package:ism_app/src/screens/login/model/login_data.dart';
import 'package:ism_app/src/services/api_constant.dart';
import 'package:ism_app/src/services/error_code.dart';

class LoginBloc extends BaseBloc<LoginEvent, BaseState> {
  LoginBloc() : super(UnInitiatedState());

  @override
  Stream<BaseState> mapEventToState(LoginEvent event) async* {
    yield* checkMobileNumber(event);
  }

  Stream<BaseState> checkMobileNumber(event) async* {
    try {
      yield LoadingState();
      if (await isConnectionAvailable()) {
        Map<String, dynamic> params = HashMap();
        params[ApiConstant.USERNAME] = (event as LoginEvent).strEmail;
        params[ApiConstant.PASSWORD] = (event as LoginEvent).strPassword;
        var response = await apiClient.call(
          url: ApiConstant.ENDPOINT_LOGIN,
          params: params,
        );
        if (response is BaseResponse) {
          LoginData loginModel = LoginData.fromJson(response.results);
          yield DataState<LoginData>(loginModel);
        } else {
          yield ErrorState(
              errorCode: (response as ErrorResponse).statusCode,
              errorMessage: (response as ErrorResponse).errorMessage);
        }
      } else {
        yield ErrorState(
            errorCode: ErrorCode.NO_INTERNET_CONNECTION,
            errorMessage: S.current.error_no_internet_connection);
      }
    } catch (e) {
      yield ErrorState(
          errorCode: ErrorCode.SERVER_DOWN,
          errorMessage: S.current.error_server_down);
    }
  }

  bool checkEmail(String strEmail) {
    return strEmail.isNotEmpty;
  }

  bool checkPassword(String strPassword) {
    return strPassword.isNotEmpty;
  }
}
