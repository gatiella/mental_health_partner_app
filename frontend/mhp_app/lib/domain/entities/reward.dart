class Reward {
  final int id;
  final String title;
  final String description;
  final int pointsRequired;
  final String? partnerName;
  final String? image;
  final DateTime? expiryDate;

  Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsRequired,
    this.partnerName,
    this.image,
    this.expiryDate,
  });
}

class UserReward {
  final int id;
  final Reward reward;
  final DateTime redeemedAt;
  final String? redemptionCode;

  UserReward({
    required this.id,
    required this.reward,
    required this.redeemedAt,
    this.redemptionCode,
  });
}
