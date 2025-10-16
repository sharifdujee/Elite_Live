import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

import '../../../logging/logger.dart';
import '../model/network_response.dart';

class NetworkCaller {
  final int timeoutDuration = 80;
  String? token;

  Future<ResponseData> getRequest(String url, {String? token}) async {
    AppLoggerHelper.info('GET Request: $url');
    try {
      final Response response = await get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': token ?? '',
        },
      ).timeout(Duration(seconds: timeoutDuration));
      log(response.headers.toString());
      log(response.statusCode.toString());
      log(response.body.toString());
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> postRequest(
    String url, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    AppLoggerHelper.info('POST Request: $url');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body)}');

    try {
      final Response response = await post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': token ?? '',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> putRequest(
    String url, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    AppLoggerHelper.info('PUT Request: $url');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body)}');

    try {
      final Response response = await put(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': token ?? '',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> deleteRequest(String url, String? token) async {
    AppLoggerHelper.info('DELETE Request: $url');
    try {
      final Response response = await delete(
        Uri.parse(url),
        headers: {
          'Authorization': token ?? "",
          'Content-type': 'application/json',
        },
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> patchRequest(
    String url, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    AppLoggerHelper.info('Patch Request: $url');
    AppLoggerHelper.info('Patch body: $body');

    try {
      final Response response = await patch(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': token ?? '',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> putFormDataWithImage(
    String res,
    String url,
    Map<String, dynamic> body,
    File imageFile, {
    String mainKey = "",
    String? token = "",
    String imageName = "profileImage",
  }) async {
    log('Request token: $token');
    log('Request Body: ${jsonEncode(body)}');

    try {
      var request = http.MultipartRequest(res, Uri.parse(url));
      request.headers.addAll({'Authorization': token ?? ""});

      String filePath = imageFile.path;
      String? mimeType = lookupMimeType(filePath);

      if (mimeType == null) {
        log('Could not determine MIME type for the file');
        return {'success': false, 'message': 'Invalid file type'};
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          imageName,
          filePath,
          contentType: MediaType.parse(mimeType),
        ),
      );
      request.fields[mainKey] = jsonEncode(body);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      log('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Success',
          'data': jsonDecode(response.body),
        };
      } else if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Success',
          'data': jsonDecode(response.body),
        };
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      debugPrint('An error occurred: $e');
      return {'success': false, 'message': 'Exception: $e'};
    }
  }

  Future<Map<String, dynamic>> putImage(
    String res,
    String url,
    Map<String, dynamic> body,
    File imageFile, {
    String? token = "",
    String imageName = "profileImage",
  }) async {
    log('Request token: $token');
    log('Request Body: ${jsonEncode(body)}');

    try {
      var request = http.MultipartRequest(res, Uri.parse(url));
      request.headers.addAll({'Authorization': token ?? ""});

      String filePath = imageFile.path;
      String? mimeType = lookupMimeType(filePath);

      if (mimeType == null) {
        log('Could not determine MIME type for the file');
        return {'success': false, 'message': 'Invalid file type'};
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          imageName,
          filePath,
          contentType: MediaType.parse(mimeType),
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      log('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Success',
          'data': jsonDecode(response.body),
        };
      } else if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Success',
          'data': jsonDecode(response.body),
        };
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      debugPrint('An error occurred: $e');
      return {'success': false, 'message': 'Exception: $e'};
    }
  }

  Future<ResponseData> sendFormDataWithImage2({
    required String url,
    required Map<String, dynamic> bodyData,
    File? profileImageFile,
    List<File>? houseUrls,
    List<File>? deedUrlsFiles,
    List<File>? billUrlsFiles,
    String? token,
  }) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(url));

      // Add JSON-encoded body data
      request.fields['bodyData'] = jsonEncode(bodyData);

      Future<void> addSingleFile(String fieldName, File? file) async {
        if (file != null) {
          final mimeType = lookupMimeType(file.path);
          AppLoggerHelper.info(
            "MIME Type ($fieldName): $mimeType for ${file.path}",
          );
          final multipartFile = await http.MultipartFile.fromPath(
            fieldName,
            file.path,
            filename: path.basename(file.path),
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          );
          request.files.add(multipartFile);
          debugPrint(
            'Added single file: ${multipartFile.filename} for field: $fieldName',
          );
        }
      }

      Future<void> addMultipleFiles(String fieldName, List<File>? files) async {
        if (files != null && files.isNotEmpty) {
          for (var file in files) {
            final mimeType = lookupMimeType(file.path);
            AppLoggerHelper.info(
              "MIME Type ($fieldName): $mimeType for ${file.path}",
            );
            final multipartFile = await http.MultipartFile.fromPath(
              fieldName,
              file.path,
              filename: path.basename(file.path),
              contentType: mimeType != null ? MediaType.parse(mimeType) : null,
            );
            request.files.add(multipartFile);
            debugPrint(
              'Added file: ${multipartFile.filename} for field: $fieldName',
            );
          }
        }
      }

      // Attach all files
      await addSingleFile('profileImage', profileImageFile);
      await addMultipleFiles('houseUrls', houseUrls);
      await addMultipleFiles('deedUrls', deedUrlsFiles);
      await addMultipleFiles('billUrls', billUrlsFiles);

      // Add authorization header if provided
      if (token != null) {
        request.headers['Authorization'] = token;
      } else {
        AppLoggerHelper.info('Warning: No authorization token provided.');
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      AppLoggerHelper.info('Response status: ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      AppLoggerHelper.error('Form data upload error: $e');
      return _handleError(e);
    }
  }

  Future<ResponseData> postCreateTenantWithImage({
    required String url,
    required Map<String, dynamic> bodyData,
    required File profileUrl,
    File? taxUrl,
    File? bankUrl,
    List<File>? rentBefore,
    String? token,
  }) async {
    try {
      var uri = Uri.parse(url);
      var request = http.MultipartRequest('POST', uri);

      if (token != null) {
        request.headers['Authorization'] = token;
      } else {
        AppLoggerHelper.info('Warning: No authorization token provided.');
      }

      request.fields['bodyData'] = jsonEncode(bodyData);

      Future<void> addFileToRequest(String fieldName, File? file) async {
        if (file != null) {
          final mimeType = lookupMimeType(file.path);
          final multipartFile = await http.MultipartFile.fromPath(
            fieldName,
            file.path,
            filename: path.basename(file.path),
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          );
          request.files.add(multipartFile);
        }else{
          return;
        }
      }

      Future<void> addMultipleFiles(String fieldName, List<File>? files) async {
        if (files != null && files.isNotEmpty) {
          for (var file in files) {
            final mimeType = lookupMimeType(file.path);
            AppLoggerHelper.info(
              "MIME Type ($fieldName): $mimeType for ${file.path}",
            );
            final multipartFile = await http.MultipartFile.fromPath(
              fieldName,
              file.path,
              filename: path.basename(file.path),
              contentType: mimeType != null ? MediaType.parse(mimeType) : null,
            );
            request.files.add(multipartFile);
            debugPrint(
              'Added file: ${multipartFile.filename} for field: $fieldName',
            );
          }
        }
      }

      await addFileToRequest('profileImage', profileUrl);
      await addFileToRequest('taxUrl', taxUrl);
      await addFileToRequest('bankUrl', bankUrl);
      await addMultipleFiles('rentBefore', rentBefore);


      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } catch (e) {
      AppLoggerHelper.error('Form data upload error: $e');
      return _handleError(e);
    }
  }

  Future<ResponseData> postDataWithImage({
    required String url,
    required Map<String, dynamic> bodyData,
    List<File>? rentBefore,
    required String name,
    String? token,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['bodyData'] = jsonEncode(bodyData);

      Future<void> addMultipleFiles(String fieldName, List<File>? files) async {
        if (files != null && files.isNotEmpty) {
          for (var file in files) {
            final mimeType = lookupMimeType(file.path);
            AppLoggerHelper.info(
              "MIME Type ($fieldName): $mimeType for ${file.path}",
            );
            final multipartFile = await http.MultipartFile.fromPath(
              fieldName,
              file.path,
              filename: path.basename(file.path),
              contentType: mimeType != null ? MediaType.parse(mimeType) : null,
            );
            request.files.add(multipartFile);
            debugPrint(
              'Added file: ${multipartFile.filename} for field: $fieldName',
            );
          }
        }
      }

      await addMultipleFiles(name, rentBefore);
      if (token != null) {
        request.headers['Authorization'] = token;
      } else {
        AppLoggerHelper.info('Warning: No authorization token provided.');
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      AppLoggerHelper.info('Response status: ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      AppLoggerHelper.error('Form data upload error: $e');
      return _handleError(e);
    }
  }

  ResponseData _handleResponse(Response response) {
    AppLoggerHelper.info('Response Status: ${response.statusCode}');
    AppLoggerHelper.info('Response Body: ${response.body}');

    final decodedResponse = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decodedResponse['success'] == true) {
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedResponse['result'],
          errorMessage: '',
        );
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: decodedResponse,
          errorMessage: decodedResponse['message'] ?? 'Unknown error occurred',
        );
      }
    } else if (response.statusCode == 400) {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage: decodedResponse['message'] ?? 'Unknown error occurred',
      );
    } else if (response.statusCode == 500) {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage:
            decodedResponse['message'] ?? 'An unexpected error occurred!',
      );
    } else {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage: decodedResponse['message'] ?? 'An unknown error occurred',
      );
    }
  }


  ResponseData _handleError(dynamic error) {
    AppLoggerHelper.info('Request Error: $error');

    if (error is ClientException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: '',
        errorMessage: 'Network error occurred. Please check your connection.',
      );
    } else if (error is TimeoutException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        responseData: '',
        errorMessage: 'Request timeout. Please try again later.',
      );
    } else {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: '',
        errorMessage: 'Unexpected error occurred.',
      );
    }
  }

  Future<Response?> getRequestForData(String url, {String? token}) async {
    AppLoggerHelper.info('GET Request: $url');
    AppLoggerHelper.info('GET Token: $url');

    Response? response;

    try {
      response = await get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': token ?? '',
        },
      ).timeout(Duration(seconds: timeoutDuration));
      final responseDecode = jsonDecode(response.body);
      if (responseDecode['success']) {
        log(response.headers.toString());
        log(response.statusCode.toString());
        log(response.body.toString());
        return response;
      }
    } catch (e) {
      return response;
    }
    return null;
  }
}
