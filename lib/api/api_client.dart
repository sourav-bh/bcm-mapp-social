import 'dart:convert';

import 'package:app/util/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiClient {

  Future<ApiResponse> getRequest(String apiEndPoint) async {
    var url = Uri.parse(Uri.encodeFull('${AppConstant.apiBaseUrl}$apiEndPoint'));
    final http.Response response = await http.get(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    debugPrint('${response.request?.url.toString()}; ${response.statusCode}; ${response.body}');
    return ApiResponse(response.body, response.statusCode, '');
  }

  Future<ApiResponse> postRequest(String apiEndPoint, Map<String, dynamic> body) async {
    var url = Uri.parse(Uri.encodeFull('${AppConstant.apiBaseUrl}$apiEndPoint'));
    final http.Response response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    return ApiResponse(response.body, response.statusCode, '');
  }

  ApiClient._privateConstructor();
  static final ApiClient instance = ApiClient._privateConstructor();
}

class ApiResponse {
  String body;
  int statusCode;
  String errorMessage;

  ApiResponse(this.body, this.statusCode, this.errorMessage);
}