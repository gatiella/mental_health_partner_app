part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String bio;
  final String mentalHealthGoals;
  final double stressLevel;
  final List<String> preferredActivities;

  const UpdateProfile({
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.mentalHealthGoals,
    required this.stressLevel,
    required this.preferredActivities,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        bio,
        mentalHealthGoals,
        stressLevel,
        preferredActivities,
      ];
}

class UpdateProfilePicture extends ProfileEvent {
  final String imagePath;

  const UpdateProfilePicture(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class ProfilePictureProgressUpdated extends ProfileEvent {
  final double progress;

  const ProfilePictureProgressUpdated(this.progress);

  @override
  List<Object> get props => [progress];
}
