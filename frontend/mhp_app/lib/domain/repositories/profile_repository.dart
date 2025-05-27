import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/data/models/user_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserModel>> getProfile();

  Future<Either<Failure, UserModel>> updateProfile({
    required String username,
    required String email,
    required String bio,
    required String firstName,
    required String lastName,
    required String mentalHealthGoals,
    required List<String> preferredActivities,
    File? profilePicture,
    required double stressLevel,
  });
}
