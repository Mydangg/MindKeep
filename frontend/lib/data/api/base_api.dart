import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/exception/api_exception.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:frontend/routing/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_field/image_field.dart';

class BaseApi {
  BaseApi(this.getToken);

  final String baseUrl = 'http://10.0.2.2:8000/api';
  final Future<String?> Function()? getToken;

  Future<dynamic> call({
    required String method,
    required String url,
    BuildContext? context,
    Map<String, dynamic>? data,
    bool requireToken = true,
    bool isMultipart = false,
    List<ImageAndCaptionModel>? files,
  }) async {
    final fullUrl = Uri.parse('$baseUrl$url');

    String? token;
    if (requireToken) {
      token = await getToken?.call();
    }

    if (isMultipart) {
      var request = http.MultipartRequest(method, fullUrl);
      if (token != null) request.headers['Authorization'] = 'Bearer $token';

      data?.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (files != null) {
        for (final fileModel in files) {
          if (fileModel.file is File) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'images',
                (fileModel.file as File).path,
              ),
            );
          } else if (fileModel.file is XFile) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'images',
                (fileModel.file as XFile).path,
              ),
            );
          } else if (fileModel.file is Uint8List) {
            request.files.add(
              http.MultipartFile.fromBytes(
                'images',
                fileModel.file as Uint8List,
                filename: 'image_${DateTime.now().millisecondsSinceEpoch}.png',
              ),
            );
          }
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return jsonDecode(response.body);
    } else {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token?.isNotEmpty ?? false) 'Authorization': 'Bearer $token',
      };

      http.Response response;

      switch (method.toUpperCase()) {
        case 'POST':
          {
            response = await http.post(
              fullUrl,
              headers: headers,
              body: jsonEncode(data),
            );
            break;
          }

        case 'GET':
          {
            response = await http.get(fullUrl, headers: headers);
            break;
          }

        case 'PUT':
          {
            response = await http.put(
              fullUrl,
              headers: headers,
              body: jsonEncode(data),
            );
            break;
          }

        case 'DELETE':
          {
            response = await http.delete(fullUrl, headers: headers);
            break;
          }

        default:
          throw Exception('HTTP method không hợp lệ: $method');
      }
      print("=================================");
      print("API URL: $fullUrl");
      print("API DATA: $data");
      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");
      print("=================================");

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return body;
      } else {
        if (response.statusCode == 403) {
          await authController.clearUser();
          final navContext = navigatorKey.currentContext;
          if (navContext != null) {
            GoRouter.of(navContext).go(PageRoutes.auth);
          }
        }
        // throw ApiException(
        //   message: body['error'] ?? 'Có lỗi xảy ra',
        //   code: response.statusCode,
        // );
        throw ApiException(
  message: body['error'] ??
      body['message'] ??
      body['detail'] ??
      body.toString(),
  code: response.statusCode,
);
      }
    }
  }
}
