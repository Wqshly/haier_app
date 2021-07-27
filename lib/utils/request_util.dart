import 'dart:convert';

import 'package:haiererp/api/api.dart';
import 'package:dio/dio.dart';

class RequestUtil {
  static final BaseOptions baseOptions = new BaseOptions(
    baseUrl: Api.basicUrl,
    connectTimeout: 3000,
    receiveTimeout: 10000,
  );

  static final Dio dio = new Dio(baseOptions);

  static Dio initInstance() {
    return dio;
  }
}
