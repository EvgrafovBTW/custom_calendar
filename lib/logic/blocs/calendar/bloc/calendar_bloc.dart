import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial(selectedDay: DateTime.now())) {
    ///! добавление нового события на календарь
    on<MarkNewDate>((event, emit) {
      List<DateTime> newMarkedDates = List.from(state.markedDays);
      if (!newMarkedDates.contains(event.date)) {
        newMarkedDates.add(event.date);
        newMarkedDates.sort();
      }
      emit(
        state.copyWith(
          selectedDay: event.date,
          markedDays: newMarkedDates,
        ),
      );
    });

    ///! выбор новой даты
    on<SelectDate>(
      (event, emit) => emit(
        state.copyWith(selectedDay: event.date),
      ),
    );
  }
}
