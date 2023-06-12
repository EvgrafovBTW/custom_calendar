import 'package:custom_calendar/logic/models/marked_date_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial(selectedDay: DateTime.now())) {
    ///! добавление нового события на календарь
    on<MarkNewDate>((event, emit) {
      List<MarkedDateEvent> newMarkedDateEvents = List.from(state.markedDays);
      if (!newMarkedDateEvents.contains(event.date)) {
        newMarkedDateEvents.add(event.date);
        newMarkedDateEvents.sort();
      }
      emit(
        state.copyWith(
          selectedDay: event.date.dateTime,
          markedDays: newMarkedDateEvents,
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
