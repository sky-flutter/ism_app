import 'package:ism_app/imports.dart';
import 'package:ism_app/src/theme/color.dart';
import 'package:ism_app/src/theme/style.dart';
import 'package:ism_app/src/widgets/button/button_solid.dart';
import 'package:ism_app/src/widgets/input/text_field_icon.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color_F8FAFB,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LoginForm(),
            ),
            LoginFooter(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isEmailFocused = false;
  bool isPasswordFocused = false;

  var isPasswordTextVisible = true;

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
              Strings.login,
              fontWeight: FontWeight.bold,
              color: MyColors.color_2FA1DB,
              fontSize: 30,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 36),
            child: MyText(
              Strings.loginDesc,
              fontWeight: FontWeight.normal,
              textAlign: TextAlign.center,
              color: MyColors.color_6E7578,
              fontSize: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 39.0, bottom: 9),
            child: MyText(
              Strings.email,
              fontWeight: FontWeight.normal,
              color: isEmailFocused
                  ? MyColors.color_F18719
                  : MyColors.color_6E7578,
              fontSize: 14,
            ),
          ),
          MyTextFieldPrefixSuffix(
            hint: Strings.email,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            outlineColor: MyColors.color_E2E9EF,
            keyboardType: TextInputType.emailAddress,
            onFocusListener: (hasFocus) {
              isEmailFocused = hasFocus;
              setState(() {});
            },
            focusedColor: MyColors.color_F18719,
            prefix: Container(
              child: Image.asset(
                Strings.icEmail,
                color: isEmailFocused
                    ? MyColors.color_F18719
                    : MyColors.color_000000,
              ),
              margin: EdgeInsets.only(left: 19),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 39.0, bottom: 9, top: 15),
            child: MyText(
              Strings.password,
              fontWeight: FontWeight.normal,
              color: isPasswordFocused
                  ? MyColors.color_F18719
                  : MyColors.color_6E7578,
              fontSize: 14,
            ),
          ),
          MyTextFieldPrefixSuffix(
            hint: Strings.password,
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
                child: Image.asset(Strings.icVisibility),
              ),
            ),
            focusedColor: MyColors.color_F18719,
            onFocusListener: (hasFocus) {
              isPasswordFocused = hasFocus;
              setState(() {});
            },
            prefix: Container(
              child: Image.asset(
                Strings.icLock,
                color: isPasswordFocused
                    ? MyColors.color_F18719
                    : MyColors.color_000000,
              ),
              margin: EdgeInsets.only(left: 19),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24, left: 20, right: 20),
            width: double.infinity,
            child: MyButton(
              Strings.login,
              () {},
              outlineColor: MyColors.color_F18719,
              textColor: MyColors.color_FFFFFF,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              buttonBgColor: MyColors.color_F18719,
            ),
          ),
        ],
      ),
    );
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
                  text: Strings.dontHaveAccount,
                  style: Style.normal
                      .copyWith(fontSize: 14, color: MyColors.color_6E7578)),
              TextSpan(
                  text: Strings.signUp,
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
