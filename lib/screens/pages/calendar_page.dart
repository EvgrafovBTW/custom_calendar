import 'package:custom_calendar/logic/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:custom_calendar/screens/components/calendar/calendar_dialog.dart';
import 'package:custom_calendar/screens/components/calendar/date_cells.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../logic/models/marked_date_model.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    CalendarBloc calendarBloc = BlocProvider.of<CalendarBloc>(context);
    ThemeData theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            return Column(
              children: [
                CustomCalendar(
                  state,
                  calendarBloc: calendarBloc,
                  theme: theme,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DateEventsList(state),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class DateEventsList extends StatelessWidget {
  const DateEventsList(
    this.state, {
    super.key,
  });
  final CalendarState state;

  @override
  Widget build(BuildContext context) {
    List<MarkedDateEvent> events = [];
    for (MarkedDateEvent event in state.markedDays) {
      if (isSameDay(state.selectedDay, event.dateTime)) {
        events.add(event);
      }
    }
    if (events.isNotEmpty) {
      return Column(
        children: [
          for (MarkedDateEvent event in events) DateEventCard(event: event),
        ],
      );
    }
    return SizedBox.fromSize(
      size: MediaQuery.of(context).size,
      child: const Text.rich(
        TextSpan(
          text: 'В этот день список событий пуст.',
          children: [
            TextSpan(text: '\nЧтобы добавить событие на дату, зажмите её.')
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class DateEventCard extends StatelessWidget {
  const DateEventCard({
    super.key,
    required this.event,
  });

  final MarkedDateEvent event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                  ),
                ),
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                ),
                if (event.description != null) Text(event.description!)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCalendar extends StatelessWidget {
  const CustomCalendar(
    this.state, {
    super.key,
    required this.calendarBloc,
    required this.theme,
  });

  final CalendarBloc calendarBloc;
  final CalendarState state;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      rowHeight: MediaQuery.of(context).size.height * 0.09,
      selectedDayPredicate: (day) {
        return isSameDay(state.selectedDay, day);
      },
      onDayLongPressed: (selectedDay, focusedDay) async {
        calendarBloc.add(SelectDate(focusedDay));
        await showPlatformDialog(
          context: context,
          material: MaterialDialogData(),
          builder: (context) {
            return CalendarDialog(selectedDay);
          },
        );
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
        //! все дни в месяце
        defaultBuilder: (context, day, focusedDay) {
          return DateCell(
            DateCellType.def,
            day: day,
          );
        },
        //! дни за пределами месяца
        outsideBuilder: (context, day, focusedDay) {
          return Container();
        },
        selectedBuilder: (context, day, focusedDay) {
          return DateCell(
            DateCellType.selected,
            day: day,
          );
        },
        todayBuilder: (context, day, focusedDay) {
          return DateCell(
            DateCellType.today,
            day: day,
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
          color: theme.colorScheme.secondary,
        ),
      ),
      // headerStyle: HeaderStyle(),
      // daysOfWeekStyle: DaysOfWeekStyle(),
    );
  }
}
