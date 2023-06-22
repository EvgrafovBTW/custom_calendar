// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'feed_bloc.dart';

class FeedState extends Equatable {
  const FeedState({
    this.year,
    this.month,
    this.inputSwithcher = false,
  });

  final int? year;
  final int? month;
  final bool inputSwithcher;

  @override
  List<dynamic> get props => [year, month, inputSwithcher];

  FeedState copyWith({
    int? year,
    int? month,
    bool? inputSwithcher,
  }) {
    return FeedState(
      year: year ?? this.year,
      month: month ?? this.month,
      inputSwithcher: inputSwithcher ?? this.inputSwithcher,
    );
  }
}

class FeedInitial extends FeedState {}
