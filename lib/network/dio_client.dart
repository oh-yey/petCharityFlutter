import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'package:pet_charity/common/config.dart';

Object? _decode(String response) => jsonDecode(response);

String _encode(Object? response) => jsonEncode(response);

parseJson(String text) => compute(_decode, text);

class DioClient extends DioForNative {
  // 私有构造函数
  DioClient._internal() {
    // 请求结果需进行json反序列化
    (transformer as SyncTransformer).jsonDecodeCallback = parseJson;
    options = BaseOptions(
        baseUrl: 'http://${Config.ip}:${Config.port}',
        connectTimeout: const Duration(seconds: 5), // 连接超时间
        receiveTimeout: const Duration(seconds: 5), // 接收超时时间
        headers: {"Accept": "application/json", "content-type": "application/json"});
    // 处理头部
    // interceptors.add(OptionInterceptor());
  }

  // 保存单例
  static final DioClient _singleton = DioClient._internal();

  // 工厂构造函数
  factory DioClient() => _singleton;

  /// 设置Token
  static set token(String? token) {
    if (token != null) {
      DioClient().options.headers['token'] = token;
    } else {
      DioClient().options.headers.remove('token');
    }
  }

  /// get请求
  doGet<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await get<T>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioError catch (e) {
      formatError(e);
      return e.response;
    }
  }

  /// post请求
  doPost<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioError catch (e) {
      formatError(e);
      return e.response;
    }
  }

  /// patch请求
  doPatch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioError catch (e) {
      formatError(e);
      return e.response;
    }
  }

  /// delete请求
  doDelete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      Response response = await delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (e) {
      formatError(e);
      return e.response;
    }
  }

  /// 上传文件
  uploadFile<T>(String uploadURL, Object? data) async {
    try {
      Response response = await doPost<T>(uploadURL, options: Options(contentType: "multipart/form-data"), data: data);
      return response;
    } on DioError catch (e) {
      formatError(e);
      return e.response;
    }
  }

  static void formatError(DioError e) {
    if (e.type == DioErrorType.connectionTimeout) {
      debugPrint("连接超时");
    } else if (e.type == DioErrorType.sendTimeout) {
      debugPrint("请求超时");
    } else if (e.type == DioErrorType.receiveTimeout) {
      debugPrint("响应超时");
    } else if (e.type == DioErrorType.badResponse) {
      debugPrint("出现异常 ${e.response?.statusCode}");
      debugPrint('${e.response?.data}');
    } else if (e.type == DioErrorType.cancel) {
      debugPrint("请求取消");
    } else {
      debugPrint(e.response.toString());
    }
  }
}
