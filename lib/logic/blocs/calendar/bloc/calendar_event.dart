part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class MarkNewDate extends CalendarEvent {
  final MarkedDateEvent date;
  const MarkNewDate(this.date);
}

class SelectDate extends CalendarEvent {
  final DateTime date;
  const SelectDate(this.date);
}
