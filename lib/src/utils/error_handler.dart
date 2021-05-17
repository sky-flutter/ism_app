import 'package:ism_app/generated/l10n.dart';
import 'package:ism_app/src/services/error_code.dart';

class ErrorHandler {
  static String getErrorMessage(int statusCode) {
    if (statusCode != null) {
      switch (statusCode) {
        case ErrorCode.NO_INTERNET_CONNECTION:
          return S.current.error_no_internet_connection;
        case ErrorCode.CONNECTION_TIMEOUT:
          return S.current.error_connection_timeout;
        case ErrorCode.SERVER_DOWN:
          return S.current.error_server_down;
        case ErrorCode.REQUEST_CANCELLED:
          return S.current.error_request_cancelled;
        default:
          return S.current.error_apiError;
      }
    } else {
      return null;
    }
  }
}
