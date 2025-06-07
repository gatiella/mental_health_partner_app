import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/reward.dart';

part 'reward_model.g.dart';

@JsonSerializable()
class RewardModel extends Reward {
  RewardModel({
    required super.id,
    required super.title,
    required super.description,
    required super.pointsRequired,
    super.partnerName,
    super.image,
    super.expiryDate,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      pointsRequired: json['pointsRequired'] as int? ?? 0,
      partnerName: json['partnerName'] as String?,
      image: json['image'] as String?,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => _$RewardModelToJson(this);
}

@JsonSerializable()
class UserRewardModel extends UserReward {
  UserRewardModel({
    required super.id,
    required RewardModel reward,
    required super.redeemedAt,
    super.redemptionCode,
  }) : super(reward: reward);

  factory UserRewardModel.fromJson(Map<String, dynamic> json) {
    return UserRewardModel(
      id: json['id'] as int? ?? 0,
      reward:
          RewardModel.fromJson(json['reward'] as Map<String, dynamic>? ?? {}),
      redeemedAt: DateTime.tryParse(json['redeemedAt']?.toString() ?? '') ??
          DateTime.now(),
      redemptionCode: json['redemptionCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$UserRewardModelToJson(this);
}
