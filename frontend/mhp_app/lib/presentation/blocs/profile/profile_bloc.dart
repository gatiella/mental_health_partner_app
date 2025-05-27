import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/data/models/user_model.dart';
import 'package:mental_health_partner/domain/repositories/profile_repository.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_event.dart';
import 'package:mental_health_partner/presentation/blocs/auth/auth_state.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  final AuthBloc authBloc;

  ProfileBloc({
    required this.profileRepository,
    required this.authBloc,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateProfilePicture>(_onUpdateProfilePicture);
  }
  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await profileRepository.getProfile();
    result.fold(
      (failure) => emit(ProfileOperationFailure(failure.message)),
      (user) => emit(ProfileLoadSuccess(user)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileOperationInProgress());
    final authState = authBloc.state;

    if (authState is! Authenticated) {
      authBloc.add(GetUserRequested());
      emit(const ProfileOperationFailure("User not authenticated"));
      return;
    }
    final currentUser = authState.user;
    final result = await profileRepository.updateProfile(
      username: currentUser.username, // Add this
      email: currentUser.email,
      firstName: event.firstName,
      lastName: event.lastName,
      bio: event.bio,
      mentalHealthGoals: event.mentalHealthGoals,
      stressLevel: event.stressLevel,
      preferredActivities: event.preferredActivities,
    );

    result.fold(
      (failure) => emit(ProfileOperationFailure(failure.message)),
      (updatedUser) {
        authBloc.add(UpdateUserData(updatedUser));
        emit(ProfileUpdateSuccess(updatedUser));
      },
    );
  }

  Future<void> _onUpdateProfilePicture(
    UpdateProfilePicture event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfilePictureUpdateInProgress(0.0));
    final authState = authBloc.state;
    if (authState is! Authenticated) {
      authBloc.add(GetUserRequested());
      emit(const ProfileOperationFailure("User not authenticated"));
      return;
    }

    final user = authState.user;
    final currentUser = authState.user;

    final result = await profileRepository.updateProfile(
      username: currentUser.username, // Add this
      email: currentUser.email, // Add this
      firstName: user.firstName ?? '',
      lastName: user.lastName ?? '',
      bio: user.bio ?? '',
      mentalHealthGoals: user.mentalHealthGoals ?? '',
      stressLevel: user.stressLevel ?? 3.0,
      preferredActivities: user.preferredActivities ?? [],
      profilePicture: File(event.imagePath),
    );

    result.fold(
      (failure) => emit(ProfileOperationFailure(failure.message)),
      (updatedUser) {
        authBloc.add(UpdateUserData(updatedUser));
        emit(ProfilePictureUpdateSuccess(updatedUser.profilePicture ?? ''));
      },
    );
  }
}
