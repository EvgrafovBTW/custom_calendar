// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class UpdateDate extends FeedEvent {
  final int? date;
  const UpdateDate(this.date);
}

class UpdateYear extends UpdateDate {
  const UpdateYear(super.date);
}

class UpdateMonth extends UpdateDate {
  const UpdateMonth(super.date);
}

class SwithYearInput extends FeedEvent {
  final bool value;
  const SwithYearInput(this.value);
}

class ClearStatistics extends FeedEvent {}
