import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ez_navy_app/model/api_base_data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HttpService {

  final timeoutDuration = const Duration(seconds: 90);

  Future<ApiBaseDataModel> apiGetRequest( String apiUrls ) async {

    http.Client client = http.Client();

    try{
      var response = await client.get(Uri.parse(apiUrls)).timeout(timeoutDuration);
      if(response.statusCode == 200){
        return ApiBaseDataModel(status: true, data: jsonDecode(response.body));
      }else{
        return ApiBaseDataModel(status: false, errorMessage: 'Something bad happend');
      }
    } on TimeoutException{
      return ApiBaseDataModel(status: false, errorMessage: 'The request time out');
    }on SocketException{
      return ApiBaseDataModel(status: false, errorMessage: 'No internet connection');
    } catch(e){
      return ApiBaseDataModel(status: false, errorMessage: e.toString());
    }finally{
      client.close();
    }
  }

  Future<ApiBaseDataModel> apiPostRequest(String apiUrl, Map<String, dynamic> bodyData) async {
    http.Client client = http.Client();

    try{
      final response = await client.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'} , body: jsonEncode(bodyData) ).timeout(timeoutDuration);

      if(response.statusCode == 201){
        return ApiBaseDataModel(status: true, data: jsonDecode(response.body));
      }
      else{
        return ApiBaseDataModel(status: false, errorMessage: 'an error happend');
      }
    } on TimeoutException{
      return ApiBaseDataModel(status: false, errorMessage: 'Server request timeout');
    } on SocketException{
      return ApiBaseDataModel(status: false, errorMessage: 'Internet connection faild');
    }catch(e){
      return ApiBaseDataModel(status: false, errorMessage: e.toString());
    } finally{
      client.close();
    }
  }

  Future<ApiBaseDataModel> apiPutRequest(String apiUrl, Map<String, dynamic> bodyData) async {
    http.Client client = http.Client();

    try{
      final response = await client.put(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'} , body: jsonEncode(bodyData) ).timeout(timeoutDuration);

      if(response.statusCode == 200){
        return ApiBaseDataModel(status: true, data: jsonDecode(response.body));
      }
      else{
        return ApiBaseDataModel(status: false, errorMessage: 'an error happend');
      }
    } on TimeoutException{
      return ApiBaseDataModel(status: false, errorMessage: 'Server request timeout');
    } on SocketException{
      return ApiBaseDataModel(status: false, errorMessage: 'Internet connection faild');
    }catch(e){
      return ApiBaseDataModel(status: false, errorMessage: e.toString());
    } finally{
      client.close();
    }
  }


  Future<ApiBaseDataModel> apiDeleteRequest(String apiUrl) async {
    http.Client client = http.Client();

    try{
      final response = await client.delete(Uri.parse(apiUrl));

      if(response.statusCode == 200){
        return ApiBaseDataModel(status: true, data: jsonDecode(response.body));
      }
      else{
        return ApiBaseDataModel(status: false, errorMessage: 'an error happend');
      }
    } on TimeoutException{
      return ApiBaseDataModel(status: false, errorMessage: 'Server request timeout');
    } on SocketException{
      return ApiBaseDataModel(status: false, errorMessage: 'Internet connection faild');
    }catch(e){
      return ApiBaseDataModel(status: false, errorMessage: e.toString());
    } finally{
      client.close();
    }
  }


  Future<ApiBaseDataModel> getRequest(
    String url, {
    Map<String, String>? bodyData,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headersData,
    required String token,
  }) async {

    http.Client client = http.Client();

    try {
      log(Uri.parse(url).replace(queryParameters: queryParams).toString());
      var request = http.MultipartRequest(
          'GET', Uri.parse(url).replace(queryParameters: queryParams));

      if (bodyData != null) request.fields.addAll(bodyData);

      var headers = {'Authorization': token};
      request.headers.addAll(headers);

      http.StreamedResponse response =
          await client.send(request).timeout(timeoutDuration);
      final body = await response.stream.bytesToString();

      if (response.statusCode > 199 && response.statusCode < 300) {
        return ApiBaseDataModel(status: true, data: body);
      } else if (response.statusCode == 412) {
        return ApiBaseDataModel(
          status: false,
          errorMessage: jsonDecode(body)['message'],
        );
      }else{
        return ApiBaseDataModel(
          status: false,
          errorMessage: jsonDecode(body)['message'],
        );
      }

    } on TimeoutException {
      return ApiBaseDataModel(
        status: false,
        errorMessage: 'The request timed out.',
      );
    } on SocketException {
      return ApiBaseDataModel(
        status: false,
        errorMessage: 'No internet connection.',
      );
    } catch (e) {
      return ApiBaseDataModel(
        status: false,
        errorMessage: e.toString(),
      );
    } finally {
      client.close();
    }
  }

  Future<ApiBaseDataModel> postRequestNotFormData(
    String url, {
    Map<String, dynamic>? bodyData,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headersData,

    required String token,
  }) async {

    http.Client client = http.Client();
    try {
      log('message');
      log(jsonEncode(bodyData));
      var request = http.Request(
          'POST', Uri.parse(url).replace(queryParameters: queryParams));
      if (bodyData != null) request.body = jsonEncode(bodyData);

      var headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
      };
      request.headers.addAll(headers);

      http.StreamedResponse response =
          await client.send(request).timeout(timeoutDuration);
      final body = await response.stream.bytesToString();
      log(body.toString());
      log(response.statusCode.toString());

      if (response.statusCode > 199 && response.statusCode < 300) {
        return ApiBaseDataModel(status: true, data: body);
      } else if (response.statusCode == 401) {
        return ApiBaseDataModel(
          status: false,
          errorMessage: jsonDecode(body)['message'],
        );
      } else {
        return ApiBaseDataModel(
          status: false,
          errorMessage: jsonDecode(body)['error'],
        );
      }
    } on TimeoutException {
      return ApiBaseDataModel(
        status: false,
        errorMessage: 'The request timed out.',
      );
    } on SocketException {
      return ApiBaseDataModel(
        status: false,
        errorMessage: 'No internet connection.',
      );
    } catch (e) {
      return ApiBaseDataModel(
        status: false,
        errorMessage: e.toString(),
      );
    } finally {
      client.close();
    }
  }

  Future<ApiBaseDataModel> postRequestFormData(
    String url, {
    Map<String, String>? data,
    Map<String, dynamic>? queryParams,

    required String token,
  }) async {
    http.Client client = http.Client();

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      if (data != null) request.fields.addAll(data);
      // if (needToken) {
      var headers = {
        'Authorization': token,
      };
      request.headers.addAll(headers);
      // }

      http.StreamedResponse response =
          await client.send(request).timeout(timeoutDuration);
      final body = await response.stream.bytesToString();
      log(body.toString());
      log(response.statusCode.toString());

      if (response.statusCode > 199 && response.statusCode < 300) {
        return ApiBaseDataModel(
          status: true,
          data: jsonDecode(body),
        );
      } else if (response.statusCode == 401) {
        return ApiBaseDataModel(
          status: false,
          errorMessage: jsonDecode(body)['error'],
        );
      } else {
        return ApiBaseDataModel(
          status: false,
          errorMessage: jsonDecode(body)['error'],
        );
      }
    } on TimeoutException {
      return ApiBaseDataModel(
        status: false,
        errorMessage: 'The request timed out.',
      );
    } on SocketException {
      return ApiBaseDataModel(
        status: false,
        errorMessage: 'No internet connection.',
      );
    } catch (e) {
      return ApiBaseDataModel(
        status: false,
        errorMessage: e.toString(),
      );
    } finally {
      client.close();
    }
  }

  

}