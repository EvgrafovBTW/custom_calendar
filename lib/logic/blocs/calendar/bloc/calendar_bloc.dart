import 'package:custom_calendar/logic/models/marked_date_model.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends HydratedBloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial(selectedDay: DateTime.now())) {
    ///! добавление нового события на календарь
    on<MarkNewDate>((event, emit) {
      List<MarkedDateEvent> newMarkedDateEvents = List.from(state.markedDays);
      if (!newMarkedDateEvents.contains(event.date)) {
        newMarkedDateEvents.add(event.date);
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

  @override
  CalendarState? fromJson(Map<String, dynamic> json) =>
      CalendarState.fromMap(json);

  @override
  Map<String, dynamic>? toJson(CalendarState state) => state.toMap();
}
