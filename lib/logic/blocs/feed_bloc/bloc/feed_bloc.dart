import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInitial()) {
    on<UpdateYear>(
      (event, emit) {
        if (event.date == null) {
          emit(
            FeedState(
              year: event.date,
              month: state.month,
            ),
          );
        } else {
          emit(state.copyWith(year: event.date));
        }
      },
    );
    on<UpdateMonth>(
      (event, emit) {
        if (event.date == null) {
          emit(
            FeedState(
              month: event.date,
              year: state.year,
            ),
          );
        } else {
          emit(state.copyWith(month: event.date));
        }
      },
    );

    on<SwithYearInput>(
      (event, emit) => emit(
        state.copyWith(
          inputSwithcher: event.value,
        ),
      ),
    );

    on<ClearStatistics>((event, emit) => emit(FeedInitial()));
  }
}
