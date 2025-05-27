// lib/presentation/blocs/community/community_bloc.dart
import 'dart:async';
import 'dart:ui';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/core/errors/failure.dart';
import 'package:mental_health_partner/domain/usecases/community/complete_challenge_usecase.dart';
import 'package:mental_health_partner/domain/usecases/community/create_forum_post_usecase.dart';
import 'package:mental_health_partner/domain/usecases/community/get_challenges_usecase.dart';
import 'package:mental_health_partner/domain/usecases/community/get_discussion_groups_usecase.dart';
import 'package:mental_health_partner/domain/usecases/community/get_forum_threads_usecase.dart';
import 'package:mental_health_partner/domain/usecases/community/get_success_stories_usecase.dart';
import 'package:mental_health_partner/domain/usecases/community/get_thread_details_usecase.dart';
import 'package:mental_health_partner/domain/usecases/community/join_challenge_usecase.dart';
import 'package:mental_health_partner/domain/usecases/community/join_discussion_group_usecase.dart';
import 'package:mental_health_partner/domain/usecases/community/send_encouragement_usecase.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_event.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final GetDiscussionGroupsUseCase getDiscussionGroups;
  final JoinDiscussionGroupUseCase joinDiscussionGroup;
  final GetForumThreadsUseCase getForumThreads;
  final CreateForumPostUseCase createForumPost;
  final GetChallengesUseCase getChallenges;
  final JoinChallengeUseCase joinChallenge;
  final GetSuccessStoriesUseCase getSuccessStories;
  final SendEncouragementUseCase sendEncouragement;
  final GetThreadDetailsUseCase getThreadDetails;
  final CompleteChallengeUseCase completeChallenge;

  CommunityBloc({
    required this.getDiscussionGroups,
    required this.joinDiscussionGroup,
    required this.getForumThreads,
    required this.createForumPost,
    required this.getChallenges,
    required this.joinChallenge,
    required this.getSuccessStories,
    required this.sendEncouragement,
    required this.getThreadDetails,
    required this.completeChallenge,
  }) : super(CommunityInitial()) {
    on<LoadDiscussionGroups>(_onLoadDiscussionGroups);
    on<JoinGroup>(_onJoinGroup);
    on<LeaveGroup>(_onLeaveGroup);
    on<LoadForumThreads>(_onLoadForumThreads);
    on<CreateForumPost>(_onCreateForumPost);
    on<LoadChallenges>(_onLoadChallenges);
    on<JoinChallenge>(_onJoinChallenge);
    on<LoadSuccessStories>(_onLoadSuccessStories);
    on<ToggleEncouragement>(_onToggleEncouragement);
    on<GetThreadDetails>(_onGetThreadDetails);
    on<CompleteChallenge>(_onCompleteChallenge);
    on<LoadForumPosts>(_onLoadForumPosts);
  }
  Future<void> _onLoadForumPosts(
    LoadForumPosts event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoading());

    final result = await getThreadDetails(threadId: event.threadId);

    result.fold(
      (failure) => emit(CommunityError(failure.message)),
      (thread) => emit(ForumPostsLoaded(
        thread.posts,
        isThreadLocked: thread.isLocked, // ✅ Add the missing parameter
      )),
    );
  }

  Future<void> _onCompleteChallenge(
    CompleteChallenge event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoading());
    final result = await completeChallenge(event.challengeId);
    _handleActionResult(emit, result, () => add(LoadChallenges()));
  }

  Future<void> _onLoadDiscussionGroups(
    LoadDiscussionGroups event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoading());
    final result = await getDiscussionGroups(topic: event.topic);
    _handleResult(emit, result, (groups) => DiscussionGroupsLoaded(groups));
  }

  Future<void> _onJoinGroup(
    JoinGroup event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoading());
    final result = await joinDiscussionGroup(
      event.groupSlug,
      isAnonymous: event.isAnonymous,
    );
    _handleActionResult(
        emit, result, () => add(LoadDiscussionGroups(topic: event.topic)));
  }

  Future<void> _onLeaveGroup(
    LeaveGroup event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoading());
    // Implement leave group logic
    // Then refresh data
    add(LoadDiscussionGroups(topic: event.topic));
  }

  Future<void> _onLoadForumThreads(
    LoadForumThreads event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoading());
    final result = await getForumThreads(groupId: event.groupId);
    _handleResult(emit, result, (threads) => ForumThreadsLoaded(threads));
  }

  Future<void> _onGetThreadDetails(
    GetThreadDetails event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoading());

    final result = await getThreadDetails(threadId: event.threadId);

    result.fold(
      (failure) => emit(CommunityError(failure.message)),
      (thread) => emit(ThreadDetailsLoaded(thread)),
    );
  }

  Future<void> _onCreateForumPost(
    CreateForumPost event,
    Emitter<CommunityState> emit,
  ) async {
    if (state is! ForumPostsLoaded) {
      emit(CommunityError('Cannot create post in current state'));
      return;
    }

    final currentState = state as ForumPostsLoaded;

    if (currentState.isThreadLocked) {
      emit(
          CommunityError('This thread is locked and cannot receive new posts'));
      return;
    }

    emit(CommunityLoading());

    final result = await createForumPost(
      threadId: event.threadId,
      content: event.content,
    );

    result.fold(
      (failure) => emit(CommunityError(failure.message)),
      (newPost) {
        emit(ForumPostsLoaded(
          [...currentState.posts, newPost],
          isThreadLocked: currentState.isThreadLocked,
        ));
      },
    );
  }

  Future<void> _onLoadChallenges(
    LoadChallenges event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoading());
    final result = await getChallenges(type: event.type);
    _handleResult(emit, result, (challenges) => ChallengesLoaded(challenges));
  }

  Future<void> _onJoinChallenge(
    JoinChallenge event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoading());
    final result = await joinChallenge(event.challengeId);
    _handleActionResult(emit, result, () => add(LoadChallenges()));
  }

  Future<void> _onLoadSuccessStories(
    LoadSuccessStories event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoading());
    final result = await getSuccessStories(category: event.category);
    _handleResult(emit, result, (stories) => SuccessStoriesLoaded(stories));
  }

  Future<void> _onToggleEncouragement(
    ToggleEncouragement event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoading());
    final result = await sendEncouragement(
      event.postId,
      type: event.type,
    );
    _handleActionResult(
      emit,
      result,
      () => EncouragementToggled(event.postId, true),
      failureCallback: () => EncouragementToggled(event.postId, false),
    );
  }

  void _handleResult<T>(
    Emitter<CommunityState> emit,
    Either<Failure, T> result,
    CommunityState Function(T) successState,
  ) {
    result.fold(
      (failure) => emit(CommunityError(_mapFailureToMessage(failure))),
      (data) => emit(successState(data)),
    );
  }

  void _handleActionResult(
    Emitter<CommunityState> emit,
    Either<Failure, bool> result,
    VoidCallback onSuccess, {
    VoidCallback? failureCallback,
  }) {
    result.fold(
      (failure) {
        emit(CommunityError(_mapFailureToMessage(failure)));
        failureCallback?.call();
      },
      (success) => onSuccess(),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case NetworkFailure:
        return 'No internet connection';
      case CacheFailure:
        return 'Failed to load local data';
      default:
        return 'Unexpected error occurred';
    }
  }
}
