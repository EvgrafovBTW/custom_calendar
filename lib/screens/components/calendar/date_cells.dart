import 'package:custom_calendar/logic/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:custom_calendar/logic/models/marked_date_model.dart';
import 'package:custom_calendar/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class DateCell extends StatelessWidget {
  const DateCell(
    this.dateType, {
    super.key,
    required this.day,
  });
  final DateTime day;
  final DateCellType dateType;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    CalendarBloc calendarBloc = BlocProvider.of<CalendarBloc>(context);

    Color? getCellColor() {
      if (dateType == DateCellType.selected) {
        return theme.colorScheme.secondary;
      }
      if (dateType == DateCellType.today) {
        return theme.colorScheme.primary;
      }
      return null;
    }

    List<MarkedDateEvent>? isDateMarked() {
      List<MarkedDateEvent>? events;
      for (MarkedDateEvent event in calendarBloc.state.markedDays) {
        if (isSameDay(event.dateTime, day)) {
          events ??= [];
          events.add(event);
        }
      }
      return events;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Container(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        decoration: BoxDecoration(
          border: Border.all(color: theme.primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: getCellColor(),
        ),
        child: SizedBox.expand(
          child: DateCellBuilder(
            dateType,
            day: day,
            markedDateEvents: isDateMarked(),
          ),
        ),
      ),
    );
  }
}

class DateCellBuilder extends StatelessWidget {
  const DateCellBuilder(
    this.dateType, {
    required this.day,
    this.markedDateEvents,
    super.key,
  });
  final DateTime day;
  final DateCellType dateType;
  final List<MarkedDateEvent>? markedDateEvents;
  @override
  Widget build(BuildContext context) {
    if (markedDateEvents != null) {
      return MarkedDateEventCellBody(
        day,
        events: markedDateEvents!,
      );
    }

    return DateCellBody(
      day: day,
    );
  }
}

class DateCellBody extends StatelessWidget {
  const DateCellBody({
    super.key,
    required this.day,
  });

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          day.day.toString(),
        ),
      ],
    );
  }
}

class MarkedDateEventCellBody extends StatelessWidget {
  const MarkedDateEventCellBody(
    this.day, {
    super.key,
    required this.events,
  });
  final DateTime day;
  final List<MarkedDateEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day.day.toString(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (events.length > 1)
                Text(
                  events.length.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: Decorations.getDateColor(context, day),
                  ),
                ),
              Icon(
                //TODO кастомную иконку
                Icons.star,
                color: Decorations.getDateColor(context, day),
                size: 15,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum DateCellType { def, selected, today }
