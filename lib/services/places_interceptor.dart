
import 'package:dio/dio.dart';


class PLacesInterceptor extends Interceptor {

  final accessToken = 'pk.eyJ1IjoiZGllZ28tdmFsZGVycmFtYS1tdSIsImEiOiJjbTIwdnh2eGwwMHNzMm9xNXF6a29kOXM1In0.Uo-wVrhKnVMGvNZX0D-KJQ';


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'access_token': accessToken,
      'language': 'es',
      'limit': 7
    });
    super.onRequest(options, handler);
  }

}