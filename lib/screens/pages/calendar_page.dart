import 'package:custom_calendar/logic/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:custom_calendar/screens/components/calendar/marked_date_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    CalendarBloc calendarBloc = BlocProvider.of<CalendarBloc>(context);
    ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Column(
        children: [
          BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              return TableCalendar(
                rowHeight: MediaQuery.of(context).size.height * 0.08,
                selectedDayPredicate: (day) {
                  return isSameDay(state.selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  calendarBloc.add(SelectDate(focusedDay));
                },
                focusedDay: state.selectedDay,
                firstDay: DateTime(1900),
                lastDay: DateTime(2100),
                startingDayOfWeek: StartingDayOfWeek.monday,
                locale: "ru_RU",
                calendarBuilders: CalendarBuilders(
                  // selectedBuilder: (context, day, focusedDay) => Container(
                  //   color: Colors.red,
                  //   child: Text(day.toIso8601String()),
                  // ),
                  //! все дни в месяце
                  defaultBuilder: (context, day, focusedDay) {
                    return DateCell(
                      day: day,
                      isMarked: day.day.isEven,
                    );
                  },
                  //! дни за пределами месяца
                  outsideBuilder: (context, day, focusedDay) {
                    return DateCell(
                      day: day,
                      isMarked: day.day.isEven,
                    );
                  },
                ),
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                },
                calendarStyle: CalendarStyle(
                  // weekendTextStyle: TextStyle(
                  //   color: theme.primaryColor,
                  // ),
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColor,
                  ),
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                headerStyle: HeaderStyle(),
                daysOfWeekStyle: DaysOfWeekStyle(),
              );
            },
          ),
        ],
      ),
    );
  }
}
