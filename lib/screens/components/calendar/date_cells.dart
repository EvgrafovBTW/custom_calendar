import 'package:custom_calendar/logic/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return theme.colorScheme.tertiary;
      }
      if (dateType == DateCellType.today) {
        return theme.colorScheme.primary;
      }
      return null;
    }

    bool isDateMarked() {
      if (calendarBloc.state.markedDays.contains(day)) {
        return true;
      }
      return false;
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
            marked: isDateMarked(),
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
    required this.marked,
    super.key,
  });
  final bool marked;
  final DateTime day;
  final DateCellType dateType;
  @override
  Widget build(BuildContext context) {
    if (marked) {
      return MarkedDateEventCellBody(day);
    }

    return DateCellBody(
      day: day,
    );
  }
}

class SelectedCellBody extends StatelessWidget {
  const SelectedCellBody({
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
  });
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color getDateColor(DateTime date) {
      if (date.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) {
        return theme.colorScheme.secondary;
      } else {
        return theme.colorScheme.onSecondary;
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day.day.toString(),
        ),
        Icon(
          //TODO кастомную иконку
          Icons.star,
          color: getDateColor(day),
        ),
      ],
    );
  }
}

enum DateCellType { def, selected, today }
