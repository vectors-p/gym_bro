import 'package:dio/dio.dart';
import 'package:gym_bro/core/constatnts/api_constants.dart';
import 'package:gym_bro/core/errors/exceptions.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: ApiConstants.headers,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    _dio.interceptors.addAll([_LoggingInterceptor(), _ErrorInterceptor()]);
  }

  Dio get dio => _dio;
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('┌── REQUEST ──────────────────────────────');
    print('│ ${options.method} ${options.uri}');
    if (options.queryParameters.isNotEmpty) {
      print('│ Params: ${options.queryParameters}');
    }
    print('└─────────────────────────────────────────');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('┌── RESPONSE ─────────────────────────────');
    print('│ ${response.statusCode} ${response.requestOptions.uri}');
    print('└─────────────────────────────────────────');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('┌── ERROR ────────────────────────────────');
    print('│ ${err.type}: ${err.message}');
    print('│ ${err.requestOptions.uri}');
    print('└─────────────────────────────────────────');
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException(
          message: 'Connection timed out. Check your internet and try again.',
        );
      case DioExceptionType.connectionError:
        throw NetworkException(message: 'No internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        throw ServerException(
          message: _messageFromStatus(statusCode),
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        throw NetworkException(message: 'Request was cancelled.');
      default:
        throw ServerException(
          message: err.message ?? 'An unexpected error occurred.',
        );
    }
  }

  String _messageFromStatus(int? statusCode) {
    return switch (statusCode) {
      400 => 'Bad request.',
      401 => 'Unauthorized. Check your API key.',
      403 => 'Forbidden. You may have exceeded your rate limit.',
      404 => 'Resource not found.',
      429 => 'Too many requests. You have exceeded the API rate limit.',
      500 => 'Internal server error. Try again later.',
      503 => 'Service unavailable. Try again later.',
      _ => 'Server error (status $statusCode).',
    };
  }
}
