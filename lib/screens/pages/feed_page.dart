import 'package:custom_calendar/logic/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:custom_calendar/logic/models/marked_date_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    CalendarBloc calendarBloc = BlocProvider.of<CalendarBloc>(context);
    return Column(
      children: [
        SafeArea(
          child: BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    for (MarkedDateEvent event in state.markedDays)
                      MarkedDateEventFeedItem(event),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class MarkedDateEventFeedItem extends StatelessWidget {
  const MarkedDateEventFeedItem(
    this.event, {
    super.key,
  });
  final MarkedDateEvent event;
  @override
  Widget build(BuildContext context) {
    String getDateString() {
      String dateString = '';
      dateString = event.dateTime
          .toIso8601String()
          .substring(0, event.dateTime.toIso8601String().indexOf('T'));
      List<String> dateContructor = dateString.split('-');
      dateContructor = dateContructor.reversed.toList();
      dateString =
          '${dateContructor.first}.${dateContructor[1]}.${dateContructor.last}';
      return dateString;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      getDateString(),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.015,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
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
