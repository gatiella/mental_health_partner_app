import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object> get props => [];
}

class LoadMoodAnalytics extends AnalyticsEvent {}

class LoadUserActivity extends AnalyticsEvent {}

class LoadCommunityEngagement extends AnalyticsEvent {}
