import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../../config/api_config.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;
  final Dio _dio;
  bool _isRefreshing = false;

  AuthInterceptor(this._secureStorage, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _secureStorage.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await _secureStorage.getRefreshToken();

        if (refreshToken != null) {
          // Try to refresh the token
          final response = await _dio.post(
            ApiConfig.fullUrl(ApiConfig.refreshToken),
            data: {'refresh': refreshToken},
            options: Options(headers: {'Authorization': null}),
          );

          if (response.statusCode == 200) {
            // Save new tokens
            await _secureStorage.setAccessToken(response.data['access']);
            await _secureStorage.setRefreshToken(response.data['refresh']);

            // Retry the original request
            final requestOptions = err.requestOptions;
            final options = Options(
              method: requestOptions.method,
              headers: {
                ...requestOptions.headers,
                'Authorization': 'Bearer ${response.data['access']}',
              },
            );

            final newResponse = await _dio.request(
              requestOptions.path,
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
              options: options,
            );

            _isRefreshing = false;
            return handler.resolve(newResponse);
          }
        }
      } catch (e) {
        _isRefreshing = false;
        // Token refresh failed, clear auth data and forward to login
        await _secureStorage.clearAll();
      }
    }

    _isRefreshing = false;
    return handler.next(err);
  }
}
