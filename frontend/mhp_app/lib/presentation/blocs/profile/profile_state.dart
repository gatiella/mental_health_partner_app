part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoadSuccess extends ProfileState {
  final UserModel user;

  const ProfileLoadSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileOperationInProgress extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final UserModel updatedUser;

  const ProfileUpdateSuccess(this.updatedUser);

  @override
  List<Object> get props => [updatedUser];
}

class ProfilePictureUpdateInProgress extends ProfileState {
  final double progress;

  const ProfilePictureUpdateInProgress(this.progress);

  @override
  List<Object> get props => [progress];
}

class ProfilePictureUpdateSuccess extends ProfileState {
  final String imageUrl;

  const ProfilePictureUpdateSuccess(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class ProfileOperationFailure extends ProfileState {
  final String error;

  const ProfileOperationFailure(this.error);

  @override
  List<Object> get props => [error];
}
