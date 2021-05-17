enum Environment { DEV, STAGING, PROD }

class ApiConstant {
  static const Environment appEnv = Environment.DEV;

  static String API_URL = "https://197.159.2.146:18410/api/";

  //Api end-points
  static const LOGIN = "auth/get_tokens";

  static var ACCESS_TOKEN = "Access-Token";

  static var AUTHORIZATION = "authorization";

  static var EMAIL = "email";
  static String USERNAME = "username";
  static var PASSWORD = "password";

  static String LANGUAGE_CODE="language_code";

  static String IS_LOGIN="is_login";
  static String LOGIN_DATA="login_data";

  static String getApiEnvLabel() {
    if (appEnv == Environment.DEV) {
      return "test";
    } else if (appEnv == Environment.STAGING) {
      return "staging";
    } else {
      return "";
    }
  }

  //Endpoint
  static var ENDPOINT_LOGIN = "auth/get_tokens";
  static var ENDPOINT_RECEIPTS = "receipts";
  static var ENDPOINT_USERS = "users";
}
