// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'calendar_bloc.dart';

class CalendarState extends Equatable {
  const CalendarState({
    required this.selectedDay,
    this.markedDays = const [],
  });
  final DateTime selectedDay;
  final List<MarkedDateEvent> markedDays;
  @override
  List<dynamic> get props => [selectedDay];

  CalendarState copyWith({
    DateTime? selectedDay,
    List<MarkedDateEvent>? markedDays,
  }) {
    return CalendarState(
      selectedDay: selectedDay ?? this.selectedDay,
      markedDays: markedDays ?? this.markedDays,
    );
  }
}

class CalendarInitial extends CalendarState {
  const CalendarInitial({required super.selectedDay});
}
