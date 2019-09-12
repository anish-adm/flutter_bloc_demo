enum HttpResponseProblem {
  /// It occurs when url is opened timeout.
  CONNECT_TIMEOUT,

  /// It occurs when url is sent timeout.
  SEND_TIMEOUT,

  ///It occurs when receiving timeout.
  RECEIVE_TIMEOUT,

  /// When the server response, but with a incorrect status, such as 404, 503...
  RESPONSE,

  /// When the request is cancelled, dio will throw a error with this type.
  CANCEL,

  /// Default error type, Some other Error. In this case, you can
  /// read the DioError.error if it is not null.
  DEFAULT,

  //Undefined error reason
  UNDEFINED,

  //Something is wrong with request (URL 404 and so on)
  REQUEST
}
class HttpResponse {
  bool ok = false;

  HttpResponseProblem problem;

  int statusCode;
  dynamic header;
  dynamic data;
  String message;

  HttpResponse(this.ok, this.problem, {this.statusCode, this.header, this.data, this.message});
}