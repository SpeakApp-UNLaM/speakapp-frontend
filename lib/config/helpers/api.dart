import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sp_front/config/helpers/param.dart';

class Api {
  static final Dio _dio = Dio();

  static void configureDio() {
    ///Base url
    _dio.options.baseUrl = Param.urlServer;
    _dio.options.headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
  }

  static void setToken(String token) {
    if (token != "") {
      _dio.options.headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    }
  }

  static Future get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final resp = await _dio.get(path, queryParameters: queryParameters);

      return resp.data;
    } on DioException catch (e) {
      Param.showToast('Error en el POST: $e');
    }
    return null;
  }

  /*static Future post(String path, final data) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      Param.showToast('Error en el POST: $e');
    }
    return "ERROR";
  }*/

  static Future post(String path, final data) async {
    try {
      final response = await _dio.post(path, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // La solicitud fue exitosa
        return response;
      } else {
        // Maneja errores de estado de respuesta HTTP aquí
        return "${response.statusCode}";
      }
    } on DioException catch (e) {
      // Maneja errores específicos de Dio (por ejemplo, errores de red)
      return "${e.response?.statusCode}";
    } catch (e) {
      // Maneja otros errores inesperados
      return "Error inesperado en el POST: $e";
    }
  }

  static Future put(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.put(path, data: formData);
      return resp.data;
    } catch (e) {
      throw ('Error en el PUT');
    }
  }

  static Future delete(String path, Map<String, dynamic> data) async {
    try {
      final resp = await _dio.delete(path, data: data);
      return resp.data;
    } catch (e) {
      throw ('Error en el delete');
    }
  }
}
