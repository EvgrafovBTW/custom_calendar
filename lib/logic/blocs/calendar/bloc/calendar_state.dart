// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'calendar_bloc.dart';

class CalendarState extends Equatable {
  const CalendarState({
    required this.selectedDay,
    this.markedDays = const [],
    this.dateCategories = const [],
  });
  final DateTime selectedDay;
  final List<MarkedDateEvent> markedDays;
  final List<String> dateCategories;

  @override
  List<dynamic> get props => [selectedDay, markedDays, dateCategories];

  CalendarState copyWith({
    DateTime? selectedDay,
    List<MarkedDateEvent>? markedDays,
    List<String>? dateCategories,
  }) {
    return CalendarState(
      selectedDay: selectedDay ?? this.selectedDay,
      markedDays: markedDays ?? this.markedDays,
      dateCategories: dateCategories ?? this.dateCategories,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'selectedDay': selectedDay.millisecondsSinceEpoch,
      'markedDays': markedDays.map((x) => x.toMap()).toList(),
      'dateCategories': dateCategories,
    };
  }

  factory CalendarState.fromMap(Map<String, dynamic> map) {
    return CalendarState(
      selectedDay:
          DateTime.fromMillisecondsSinceEpoch(map['selectedDay'] as int),
      markedDays: List<MarkedDateEvent>.from(
        (map['markedDays'] as List).map<MarkedDateEvent>(
          (x) => MarkedDateEvent.fromMap(x as Map<String, dynamic>),
        ),
      ),
      dateCategories:
          List<String>.from((map['dateCategories'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory CalendarState.fromJson(String source) =>
      CalendarState.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CalendarInitial extends CalendarState {
  const CalendarInitial({required super.selectedDay});
}
