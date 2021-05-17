import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ism_app/imports.dart';
import 'package:ism_app/src/bloc/base_state.dart';
import 'package:ism_app/src/screens/login/bloc/login_bloc.dart';
import 'package:ism_app/src/screens/login/model/login_data.dart';
import 'package:ism_app/src/services/api_constant.dart';
import 'package:ism_app/src/theme/color.dart';
import 'package:ism_app/src/theme/style.dart';
import 'package:ism_app/src/utils/error_handler.dart';
import 'package:ism_app/src/utils/preference.dart';
import 'package:ism_app/src/widgets/button/button_solid.dart';
import 'package:ism_app/src/widgets/input/text_field_icon.dart';
import 'package:ism_app/src/widgets/loading/loader.dart';

import 'bloc/login_event.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => _loginBloc,
      child: BlocListener<LoginBloc, BaseState>(
        listener: (BuildContext context, state) async {
          if (state is ErrorState) {
            showSnackBar(
                S.of(context).error,
                state.errorMessage ??
                    ErrorHandler.getErrorMessage(state.errorCode) ??
                    "");
          }

          if (state is DataState) {
            await MyPreference.add(
                ApiConstant.LOGIN_DATA,
                json.encode((state.data as LoginData).toJson()),
                SharePrefType.String);
            await MyPreference.add(
                ApiConstant.IS_LOGIN, true, SharePrefType.Bool);
            //Show Success
            MyNavigator.pushReplacedNamed(Routes.strHomeRoute);
          }
        },
        child: Scaffold(
          backgroundColor: MyColors.color_F8FAFB,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: LoginForm(_loginBloc),
                ),
                LoginFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  saveUserLoginDetails(String strJson) async {
    await MyPreference.add(ApiConstant.IS_LOGIN, true, SharePrefType.Bool);
    await MyPreference.add(
        ApiConstant.LOGIN_DATA, strJson, SharePrefType.String);
  }
}

class LoginForm extends StatefulWidget {
  LoginBloc loginBloc;

  LoginForm(this.loginBloc);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isEmailFocused = false;
  bool isPasswordFocused = false;

  var isPasswordTextVisible = true;

  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Image.asset(
              Strings.splashLogo,
              height: rWidth(45),
              width: rWidth(45),
            ),
            margin: const EdgeInsets.only(top: 21, bottom: 36),
            alignment: Alignment.topCenter,
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 8),
            child: MyText(
              S.of(context).log_in,
              fontWeight: FontWeight.bold,
              color: MyColors.color_2FA1DB,
              fontSize: 30,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 36),
            child: MyText(
              S.of(context).login_into_app,
              fontWeight: FontWeight.normal,
              textAlign: TextAlign.center,
              color: MyColors.color_6E7578,
              fontSize: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 39.0, bottom: 9),
            child: MyText(
              S.of(context).email,
              fontWeight: FontWeight.normal,
              color: isEmailFocused
                  ? MyColors.color_F18719
                  : MyColors.color_6E7578,
              fontSize: 14,
            ),
          ),
          MyTextFieldPrefixSuffix(
            hint: S.of(context).email,
            controller: ctrlEmail,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            outlineColor: MyColors.color_E2E9EF,
            keyboardType: TextInputType.emailAddress,
            onFocusListener: (hasFocus) {
              isEmailFocused = hasFocus;
              setState(() {});
            },
            focusedColor: MyColors.color_F18719,
            prefix: Container(
              child: Icon(
                Icons.mail_outline_rounded,
                color: isEmailFocused
                    ? MyColors.color_F18719
                    : MyColors.color_3F4446,
              ),
              margin: EdgeInsets.only(left: 19),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 39.0, bottom: 9, top: 15),
            child: MyText(
              S.of(context).password,
              fontWeight: FontWeight.normal,
              color: isPasswordFocused
                  ? MyColors.color_F18719
                  : MyColors.color_3F4446,
              fontSize: 14,
            ),
          ),
          MyTextFieldPrefixSuffix(
            hint: S.of(context).password,
            controller: ctrlPassword,
            isObscureText: isPasswordTextVisible,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            outlineColor: MyColors.color_E2E9EF,
            keyboardType: TextInputType.text,
            suffix: Container(
              margin: const EdgeInsets.only(right: 19),
              child: GestureDetector(
                onTap: () {
                  isPasswordTextVisible = !isPasswordTextVisible;
                  setState(() {});
                },
                child: Icon(isPasswordTextVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
              ),
            ),
            focusedColor: MyColors.color_F18719,
            onFocusListener: (hasFocus) {
              isPasswordFocused = hasFocus;
              setState(() {});
            },
            prefix: Container(
              child: Icon(
                Icons.lock_outline_rounded,
                color: isPasswordFocused
                    ? MyColors.color_F18719
                    : MyColors.color_3F4446,
              ),
              margin: EdgeInsets.only(left: 19),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24, left: 20, right: 20),
            width: double.infinity,
            child: BlocBuilder<LoginBloc, BaseState>(
              builder: (BuildContext context, state) {
                if (state is LoadingState) {
                  return Loader();
                }
                return MyButton(
                  S.of(context).log_in,
                  () {
                    checkValidation();
                  },
                  outlineColor: MyColors.color_F18719,
                  textColor: MyColors.color_FFFFFF,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  buttonBgColor: MyColors.color_F18719,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void checkValidation() {
    if (!widget.loginBloc.checkEmail(ctrlEmail.text.toString())) {
      showSnackBar(S.of(context).error, S.of(context).error_enter_email);
      return;
    }
    if (!widget.loginBloc.checkPassword(ctrlPassword.text.toString())) {
      showSnackBar(S.of(context).error, S.of(context).error_enter_password);
      return;
    }

    widget.loginBloc.add(
        LoginEvent(ctrlEmail.text.toString(), ctrlPassword.text.toString()));
  }
}

class LoginFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            Strings.loginBottomImage,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 24),
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: S.of(context).dont_have_account,
                  style: Style.normal
                      .copyWith(fontSize: 14, color: MyColors.color_6E7578)),
              TextSpan(
                  text: S.of(context).signup,
                  style: Style.normal.copyWith(
                      fontSize: 14,
                      color: MyColors.color_2FA2DB,
                      fontWeight: FontWeight.bold)),
            ])),
          ),
        ],
      ),
    );
  }
}
