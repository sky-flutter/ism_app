import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ism_app/main.dart';
import 'package:ism_app/src/bloc/base_state.dart';
import 'package:ism_app/src/model/base_response.dart';
import 'package:ism_app/src/screens/login/bloc/login_event.dart';
import 'package:ism_app/src/screens/login/model/login_data.dart';
import 'package:ism_app/src/services/api_constant.dart';
import 'package:ism_app/src/services/error_code.dart';

class LoginBloc extends Bloc<LoginEvent, BaseState> {
  LoginBloc() : super(UnInitiatedState());

  @override
  Stream<BaseState> mapEventToState(LoginEvent event) async* {
    yield* checkMobileNumber(event);
  }

  Stream<BaseState> checkMobileNumber(event) async* {
    try {
      yield LoadingState();
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
    } catch (e) {
      yield ErrorState(errorCode: ErrorCode.SERVER_DOWN);
    }
  }

  bool checkEmail(String strEmail) {
    return strEmail.isNotEmpty;
  }

  bool checkPassword(String strPassword) {
    return strPassword.isNotEmpty;
  }
}
