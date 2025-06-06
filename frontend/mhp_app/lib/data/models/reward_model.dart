import 'package:json_annotation/json_annotation.dart';

part 'reward_model.g.dart';

@JsonSerializable()
class RewardModel {
  final int id;
  final String title;
  final String description;
  final int pointsRequired;
  final String? partnerName;
  final String? image;
  final DateTime? expiryDate;

  RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsRequired,
    this.partnerName,
    this.image,
    this.expiryDate,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) =>
      _$RewardModelFromJson(json);

  Map<String, dynamic> toJson() => _$RewardModelToJson(this);
}

@JsonSerializable()
class UserRewardModel {
  final int id;
  final RewardModel reward;
  final DateTime redeemedAt;
  final String? redemptionCode;

  UserRewardModel({
    required this.id,
    required this.reward,
    required this.redeemedAt,
    this.redemptionCode,
  });

  factory UserRewardModel.fromJson(Map<String, dynamic> json) =>
      _$UserRewardModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserRewardModelToJson(this);
}

// @JsonSerializable()
// class UserPointsModel {
//   final int totalPoints;
//   final int currentPoints;
//   final DateTime lastUpdated;

//   UserPointsModel({
//     required this.totalPoints,
//     required this.currentPoints,
//     required this.lastUpdated,
//   });

//   factory UserPointsModel.fromJson(Map<String, dynamic> json) =>
//       _$UserPointsModelFromJson(json);

//   Map<String, dynamic> toJson() => _$UserPointsModelToJson(this);
// }
