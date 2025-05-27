class AppConstants {
  static const int apiTimeout = 30000; // 30 seconds
  static const int paginationLimit = 20;
  static const int maxProfilePictureSize = 2097152; // 2MB
  static const String defaultProfilePicture =
      'assets/images/default_avatar.png';
  static const List<String> allowedMoods = [
    'Happy',
    'Sad',
    'Neutral',
    'Anxious',
    'Calm'
  ];
}
