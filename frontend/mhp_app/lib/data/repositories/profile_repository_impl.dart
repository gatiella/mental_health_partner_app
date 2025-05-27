import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/core/network/api_client.dart';
import 'package:mental_health_partner/core/storage/local_storage.dart';
import 'package:mental_health_partner/data/models/user_model.dart';
import 'package:mental_health_partner/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient client;
  final LocalStorage localStorage;

  const ProfileRepositoryImpl({
    required this.client,
    required this.localStorage,
  });

  @override
  Future<Either<Failure, UserModel>> getProfile() async {
    try {
      final response = await client.get('/profile');
      return Right(UserModel.fromJson(response.data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile({
    required String username, // Add this
    required String email, // Add this
    required String firstName,
    required String lastName,
    required String bio,
    required String mentalHealthGoals,
    required double stressLevel,
    required List<String> preferredActivities,
    File? profilePicture,
  }) async {
    try {
      final data = {
        'username': username, // Add this
        'email': email, // Add this
        'first_name': firstName,
        'last_name': lastName,
        'bio': bio,
        'mental_health_goals': mentalHealthGoals,
        'stress_level': stressLevel,
        'preferred_activities': preferredActivities,
      };

      final formData = FormData.fromMap({
        ...data,
        if (profilePicture != null)
          'profile_picture': await MultipartFile.fromFile(profilePicture.path),
      });

      // Explicitly retrieve the auth token from localStorage using the correct method
      final token = localStorage.getString(
          'auth_token'); // Using the getString method for token retrieval

      // Make the request with the token in the headers
      final response = await client.put(
        '/api/users/profile/',
        data: formData,
        options: Options(
          headers: {
            // Keep the content type header for multipart/form-data
            'Content-Type': 'multipart/form-data',
            // Add the authorization header with the token
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return Right(UserModel.fromJson(response.data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
