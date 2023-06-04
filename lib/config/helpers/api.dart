import 'dart:io';

import 'package:dio/dio.dart';

class Api {
  static final Dio _dio = Dio();

  static void configureDio(String urlServer) {
    ///Base url
    _dio.options.baseUrl = urlServer;
    _dio.options.headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
  }

  static Future httpGet(String path) async {
    try {
      final resp = await _dio.get(
        path,
      );

      return resp.data;
    } catch (e) {
      print(e);
      throw ('Error en el GET');
    }
  }

  static Future<Response> post(String path, FormData data) async {
    try {
      return await _dio.post(path, data: data);
    } on DioError catch (e) {
      throw ('Error en el POST: $e');
    }
  }

  static Future put(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.put(path, data: formData);
      return resp.data;
    } catch (e) {
      print(e);
      throw ('Error en el PUT');
    }
  }

  static Future delete(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.delete(path, data: formData);
      return resp.data;
    } catch (e) {
      print(e);
      throw ('Error en el delete');
    }
  }
}
