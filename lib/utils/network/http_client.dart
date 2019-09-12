import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter_bloc_demo/utils/network/http_response.dart';
class HttpClient {
  final Client _client = Client();
  static String _host, _scheme;
  static bool _enableDebugging;
  

  static final HttpClient _httpClient =
  new HttpClient._internal();

  HttpClient._internal();

  factory HttpClient(String baseUrl, bool enableDebugging, String scheme) {

    _host = baseUrl;
    _enableDebugging = enableDebugging;
    _scheme = scheme;

    return _httpClient;
  }

  static HttpClient get instance {
    return _httpClient;
  }

  Future<HttpResponse> get(dynamic endpoint,
      {Map<String, String> queryParameters,
        Map<String, String> headers}) async {
    try {
      Uri uri;
      if(endpoint is String){
        /// Create URI for API call
        uri = Uri(
            scheme: _scheme,
            host: _host,
            path: endpoint,
            queryParameters: queryParameters);
      }else{
        uri = endpoint as Uri;
      }

      print(uri.toString());

      /// API call with GET method
      Response response = await _client.get(uri, headers: headers);
      print(response.body);
      print(response.statusCode);
      _logResponse(response);
      /// We got the response to the server, Create response based on server reply
      return _createResponse(response);
    } catch (exception) {
      print("At http exception");
      if (_enableDebugging) print(exception);
      // ToDo: Write Log
      /// Something went wrong, create negative response
      return HttpResponse(false, HttpResponseProblem.UNDEFINED);
    }
  }

  Future<HttpResponse> patch(String endpoint,
      {dynamic data,
        Map<String, String> queryParameters,
        Map<String, String> headers,
        Encoding encoding}) async {
    try {
      /// Create URI for API call
      Uri uri = Uri(
          scheme: _scheme,
          host: _host,
          path: endpoint,
          queryParameters: queryParameters);

      /// API call with POST method
      ///
      /// [data] should be in the same content-type as we want to send it to server. This class does not support converting request body based on content type in header or default yo JSON
      // ToDo: Add support for check/conversion of request body to appropriate format based on content-type in header or default to json
      Response response = await _client.patch(uri,
          body: data, headers: headers, encoding: encoding);
      _logResponse(response, requestBody: data);

      /// We got the response from the server, Create response based on server reply
      return _createResponse(response);
    } catch (exception) {
      if (_enableDebugging) print(exception);
      // ToDo: Write Log
      /// Something went wrong, create negative response
      return HttpResponse(false, HttpResponseProblem.UNDEFINED);
    }
  }

  HttpResponse _createResponse(Response response) {
    try{
      String contentType = response.headers['content-type'];

      /// Handling positive response [200-299]
      if (response.statusCode >= 200 || response.statusCode <= 299) {
        dynamic responseBody = response.body;

        /// Convert body from Json to Map if response content-type is application/json
        if (contentType != null && contentType.contains('application/json')) {
          responseBody = jsonDecode(responseBody);
        }

        /// Do not convert response in case response content-type is not json
        return HttpResponse(true, null,
            data: responseBody,
            header: response.headers,
            statusCode: response.statusCode);

        /// Handling CLIENT_ERROR [400-499]
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        return HttpResponse(false, HttpResponseProblem.REQUEST);

        /// Handling SERVER_ERROR [500-599]
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        return HttpResponse(false, HttpResponseProblem.RESPONSE);
      } else {
        return HttpResponse(false, HttpResponseProblem.UNDEFINED);
      }
    }catch(exception){
      print(exception);
      return HttpResponse(false, HttpResponseProblem.UNDEFINED);
    }

  }

  void _logResponse(Response response, {dynamic requestBody}) {
    if (_enableDebugging) {
      print("*******Request*******\n${response.request}");
      print("Header: ${response.request.headers}");
      print("Body: ${requestBody}");
      print("*******Response:*******");
      print("Statuus Code: ${response.statusCode}");
      print("Body: ${response.body}");
      print("Header: ${response.headers}");
    }
  }
}