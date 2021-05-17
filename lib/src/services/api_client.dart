import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/headers.dart' as Headers;
import 'package:flutter/foundation.dart';
import 'package:ism_app/src/model/base_response.dart';
import 'package:ism_app/src/services/error_code.dart';
import 'package:ism_app/src/utils/preference.dart';
import 'package:logger/logger.dart';

import 'api_constant.dart';

class ApiClient {
  Dio dio;
  String userId = "", authToken = "";
  Map<String, String> headers;

  Logger logger = Logger(printer: PrettyPrinter());
  String accessToken;
  static final ApiClient instance = ApiClient._internal();

  ApiClient._internal();

  setUpClient() {
    dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    var interceptor = InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      if (kDebugMode) {
        logger.i("Request : URL : ${options.uri.toString()} "
            "DATA : ${options.data} "
            "HEADERS : ${options.headers.toString()}");
      }
      handler.next(options);
    }, onResponse: (
      Response response,
      ResponseInterceptorHandler handler,
    ) {
      if (kDebugMode) {
        logger.i("Response : ${response.data}");
      }
      handler.next(response);
    }, onError: (
      DioError e,
      ErrorInterceptorHandler handler,
    ) {
      if (kDebugMode) {
        logger.e("Error : ${e.error}");
      }
      handler.next(e);
    });

    dio.interceptors.add(interceptor);
  }

  checkIsLogin() async {
    var isContain = await MyPreference.containsKey(ApiConstant.ACCESS_TOKEN);
    if (isContain) {
      authToken = await getAccessToken();
    } else {
      return "";
    }
  }

  Future<ApiResponse> call(
      {String url,
      Map<String, dynamic> params,
      ApiMethod method = ApiMethod.GET,
      FormData fileUploadData,
      Map<String, dynamic> mHeader,
      formUrlEncoded = false,
      String token}) async {
    try {
      await checkIsLogin();
      if (authToken != "") {
        headers = {
          ApiConstant.ACCESS_TOKEN: authToken,
        };
      }

      try {
        if (headers == null) headers = {};
        if (mHeader != null) {
          headers.addAll(mHeader);
        }
      } catch (e) {}

      url = ApiConstant.API_URL + url;
      var response;
      switch (method) {
        case ApiMethod.GET:
          response = await dio.get(url,
              queryParameters: params, options: Options(headers: headers));
          break;
        case ApiMethod.POST:
          response = await dio.post(url,
              data: params,
              options: Options(
                  headers: headers,
                  contentType: Headers.Headers.formUrlEncodedContentType));
          break;
        case ApiMethod.MULTIPART:
          response = await dio.post(url,
              data: fileUploadData, options: Options(headers: headers));
          break;
        case ApiMethod.DELETE:
          response = await dio.delete(url,
              queryParameters: params, options: Options(headers: headers));
          break;
        case ApiMethod.PUT:
          response = await dio.put(url,
              queryParameters: params, options: Options(headers: headers));
          break;
        default:
          return ApiResponse.error(
              errorMessage: "You have set wrong http method");
      }
      if (response != null) {
        BaseResponse _baseResponse = ApiResponse.success(response.data);
        return _baseResponse;
        // if(_baseResponse.success && _baseResponse.statusCode==200){
        //   return _baseResponse;
        // }else{
        // return ErrorResponse(statusCode: _baseResponse.statusCode,errorMessage: _baseResponse.message);
        // }
      }
    } on SocketException {
      return ApiResponse.error(statusCode: ErrorCode.NO_INTERNET_CONNECTION);
    } on FormatException {
      return ApiResponse.error(statusCode: ErrorCode.SERVER_DOWN);
    } on DioError catch (e) {
      var statusCode;
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout) {
        statusCode = ErrorCode.CONNECTION_TIMEOUT;
      } else if (e.type == DioErrorType.other) {
        statusCode = ErrorCode.NO_INTERNET_CONNECTION;
      } else if (e.type == DioErrorType.cancel) {
        statusCode = ErrorCode.REQUEST_CANCELLED;
      } else if (e.response.statusCode == ErrorCode.NOT_AUTHORIZED) {
        statusCode = ErrorCode.NOT_AUTHORIZED;
      } else if (e.response.statusCode == ErrorCode.SESSION_EXPIRED) {
        statusCode = ErrorCode.SESSION_EXPIRED;
      } else {
        statusCode = ErrorCode.SERVER_DOWN;
      }
      return ApiResponse.error(statusCode: statusCode);
    }
  }

  getAccessToken() async {
    try {
      return await MyPreference.get(
          ApiConstant.ACCESS_TOKEN, SharePrefType.String);
    } catch (e) {}
  }
}

enum ApiMethod { GET, POST, MULTIPART, DELETE, PUT }
