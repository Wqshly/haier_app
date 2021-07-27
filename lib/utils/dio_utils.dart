import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:haiererp/api/api.dart';

import 'error_handle.dart';

typedef Success<T> = Function(T data);
typedef BackError = Function(int code, String msg);

class DioUtil {
  static Dio dio = new Dio();

  //普通格式的header
  static final Map<String, dynamic> headers = {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
  };

  //json格式的header
  static final Map<String, dynamic> headersJson = {
    "Accept": "application/json",
    "Content-Type": "application/json; charset=UTF-8",
  };

  static final BaseOptions baseOptions = new BaseOptions(
    baseUrl: Api.basicUrl,
    connectTimeout: 3000,
    receiveTimeout: 10000,
    //如果返回数据是json(content-type)，
    // dio默认会自动将数据转为json，
    // 无需再手动转](https://github.com/flutterchina/dio/issues/30)
    responseType: ResponseType.plain,
    headers: headers,
  );

  static Dio createInstance() {
    if (dio.options.baseUrl.isEmpty) {
      dio = new Dio(baseOptions);
    }
    return dio;
  }

  // 清空 dio 对象
  static clear() {
    dio.clear();
  }

  static Future request<T>(Method method, String msg, dynamic params,
      {Success? success, BackError? backError}) async {
//    try {
//
//    }
  }

  // 查看当前网络是否可用
  void connectCheck(BackError backError) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      backError(ExceptionHandle.net_error, '网络异常，请检查你的网络！');
      return;
    }
  }
}

enum Method { GET, POST, DELETE, PUT, PATCH, HEAD }
