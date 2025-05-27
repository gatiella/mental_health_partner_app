// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardModel _$RewardModelFromJson(Map<String, dynamic> json) => RewardModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      pointsRequired: (json['pointsRequired'] as num).toInt(),
      partnerName: json['partnerName'] as String?,
      image: json['image'] as String?,
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
    );

Map<String, dynamic> _$RewardModelToJson(RewardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'pointsRequired': instance.pointsRequired,
      'partnerName': instance.partnerName,
      'image': instance.image,
      'expiryDate': instance.expiryDate?.toIso8601String(),
    };

UserRewardModel _$UserRewardModelFromJson(Map<String, dynamic> json) =>
    UserRewardModel(
      id: (json['id'] as num).toInt(),
      reward: RewardModel.fromJson(json['reward'] as Map<String, dynamic>),
      redeemedAt: DateTime.parse(json['redeemedAt'] as String),
      redemptionCode: json['redemptionCode'] as String?,
    );

Map<String, dynamic> _$UserRewardModelToJson(UserRewardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reward': instance.reward,
      'redeemedAt': instance.redeemedAt.toIso8601String(),
      'redemptionCode': instance.redemptionCode,
    };

UserPointsModel _$UserPointsModelFromJson(Map<String, dynamic> json) =>
    UserPointsModel(
      totalPoints: (json['totalPoints'] as num).toInt(),
      currentPoints: (json['currentPoints'] as num).toInt(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$UserPointsModelToJson(UserPointsModel instance) =>
    <String, dynamic>{
      'totalPoints': instance.totalPoints,
      'currentPoints': instance.currentPoints,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
