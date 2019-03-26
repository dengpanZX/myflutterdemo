import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:io';

Options options= new Options(
    baseUrl:"http://www.bitqq.vip",
    connectTimeout:5000,
    receiveTimeout:3000
);
var dio = new Dio(options);

class NetUtils {
  static Future get(String url, {Map<String, dynamic> params}) async {
    dio.onHttpClientCreate = (HttpClient client) {
      client.findProxy = (url) {
        return HttpClient.findProxyFromEnvironment(url, environment: {"http_proxy": 'http://192.168.1.32:9999',});
      };
    };
    var response = await dio.get(url, data: params);
    return response.data;
  }

  static Future post(String url, Map<String, dynamic> params) async {
    var response = await dio.post(url, data: params);
    return response.data;
  }
}
