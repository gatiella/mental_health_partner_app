import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData);
  Future<UserModel> getUserProfile();
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
  Future<Map<String, dynamic>> verifyEmail(String token);
  Future<Map<String, dynamic>> forgotPassword(String email); // Add this
  Future<Map<String, dynamic>> resetPassword(String token, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await client.post(
        ApiConfig.login,
        data: {'email': email, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final errorData = e.response?.data;
        if (errorData is Map<String, dynamic> && errorData['error'] != null) {
          throw UnauthorizedException(message: errorData['error']);
        }
        throw UnauthorizedException(message: 'Invalid credentials');
      }
      throw ServerException(message: e.message ?? 'Server error');
    }
  }

  @override
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await client.post(ApiConfig.register, data: userData);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ValidationException(message: json.encode(e.response?.data));
      }
      throw ServerException(message: e.message ?? 'Server error');
    }
  }

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final response = await client.get(ApiConfig.userProfile);
      // If the response is directly the user object
      if (response.data is Map<String, dynamic>) {
        return UserModel.fromJson(response.data);
      }
      // If the response has a nested user object
      else if (response.data['user'] != null) {
        return UserModel.fromJson(response.data['user']);
      }
      throw ServerException(message: 'Invalid response format');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException(message: 'User not authenticated');
      }
      throw ServerException(message: e.message ?? 'Server error');
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await client.post(
        ApiConfig.refreshToken,
        data: {'refresh': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );
      return response.data;
    } on DioException {
      throw UnauthorizedException(message: 'Failed to refresh token');
    }
  }

  @override
  Future<Map<String, dynamic>> verifyEmail(String token) async {
    try {
      final response = await client.post('${ApiConfig.verifyEmail}/$token/');
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData is Map<String, dynamic> && errorData['error'] != null) {
          throw ValidationException(message: errorData['error']);
        }
        throw ValidationException(message: 'Invalid verification token');
      }
      throw ServerException(message: e.message ?? 'Server error');
    }
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await client.post(
        ApiConfig.forgotPassword,
        data: {'email': email},
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Server error');
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
      String token, String password) async {
    try {
      final response = await client.post(
        '${ApiConfig.resetPassword}/$token/',
        data: {'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData is Map<String, dynamic> && errorData['error'] != null) {
          throw ValidationException(message: errorData['error']);
        }
        throw ValidationException(message: 'Invalid reset token');
      }
      throw ServerException(message: e.message ?? 'Server error');
    }
  }
}
