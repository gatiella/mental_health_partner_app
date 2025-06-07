// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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

Map<String, dynamic> _$UserRewardModelToJson(UserRewardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reward': instance.reward,
      'redeemedAt': instance.redeemedAt.toIso8601String(),
      'redemptionCode': instance.redemptionCode,
    };
