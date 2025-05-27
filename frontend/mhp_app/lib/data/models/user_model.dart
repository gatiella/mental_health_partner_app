import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String email;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? bio;
  final String? mentalHealthGoals;
  final double? stressLevel;
  final List<String>? preferredActivities;
  final String? dateOfBirth; // <-- Added field

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    this.profilePicture,
    required this.createdAt,
    this.updatedAt,
    this.bio,
    this.mentalHealthGoals,
    this.stressLevel,
    this.preferredActivities,
    this.dateOfBirth, // <-- Constructor update
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        email: json['email'],
        username: json['username'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        profilePicture: json['profile_picture'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
        bio: json['bio'],
        mentalHealthGoals: json['mental_health_goals'],
        stressLevel: json['stress_level']?.toDouble(),
        preferredActivities:
            _parsePreferredActivities(json['preferred_activities']),
        dateOfBirth: json['date_of_birth'], // <-- JSON parse
      );

  static List<String>? _parsePreferredActivities(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      if (value.isEmpty) return [];
      return [value];
    }
    if (value is List) {
      return List<String>.from(value);
    }
    return [];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'profile_picture': profilePicture,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'bio': bio,
        'mental_health_goals': mentalHealthGoals,
        'stress_level': stressLevel,
        'preferred_activities': preferredActivities,
        'date_of_birth': dateOfBirth, // <-- JSON output
      };

  UserModel copyWith({
    int? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? profilePicture,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? bio,
    String? mentalHealthGoals,
    double? stressLevel,
    List<String>? preferredActivities,
    String? dateOfBirth, // <-- copyWith
  }) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        username: username ?? this.username,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        profilePicture: profilePicture ?? this.profilePicture,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        bio: bio ?? this.bio,
        mentalHealthGoals: mentalHealthGoals ?? this.mentalHealthGoals,
        stressLevel: stressLevel ?? this.stressLevel,
        preferredActivities: preferredActivities ?? this.preferredActivities,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth, // <-- Set
      );

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        firstName,
        lastName,
        profilePicture,
        createdAt,
        updatedAt,
        bio,
        mentalHealthGoals,
        stressLevel,
        preferredActivities,
        dateOfBirth, // <-- Included in props
      ];
}
