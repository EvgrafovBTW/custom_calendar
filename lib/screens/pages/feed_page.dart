import 'package:custom_calendar/logic/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:custom_calendar/logic/blocs/feed_bloc/bloc/feed_bloc.dart';
import 'package:custom_calendar/logic/models/marked_date_model.dart';
import 'package:custom_calendar/screens/components/feed/statistics_date_picker.dart';
import 'package:custom_calendar/screens/consecutive_screens/date_event_screen.dart';
import 'package:custom_calendar/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    FeedBloc feedBloc = BlocProvider.of<FeedBloc>(context, listen: false);
    void chooseStatisticsMonth() async {
      await showPlatformModalSheet(
        material: MaterialModalSheetData(),
        cupertino: CupertinoModalSheetData(),
        context: context,
        builder: (context) {
          return const StatisticsDatePicker();
        },
      );
    }

    void clearStatisctics() {
      feedBloc.add(ClearStatistics());
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(
                text: "Лента",
              ),
              Tab(
                text: "Статистика",
              ),
            ],
          ),
          bottom: AppBar(
            title: GestureDetector(
              onTap: chooseStatisticsMonth,
              child: BlocBuilder<FeedBloc, FeedState>(
                builder: (context, state) {
                  if (state.month != null && state.year != null) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${Utils.monthsById[state.month]} ${state.year}'),
                        IconButton(
                          onPressed: clearStatisctics,
                          icon: Icon(
                            Icons.clear,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    );
                  }

                  if (state.month == null && state.year != null) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('За ${state.year} год'),
                        IconButton(
                          onPressed: clearStatisctics,
                          icon: Icon(
                            Icons.clear,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text('За всё время');
                },
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: chooseStatisticsMonth,
              icon: const Icon(Icons.date_range_outlined),
            )
          ],
        ),
        body: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            return const TabBarView(
              children: [
                DatesFeed(),
                MarksStatistics(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MarksStatistics extends StatefulWidget {
  const MarksStatistics({
    super.key,
  });

  @override
  State<MarksStatistics> createState() => _MarksStatisticsState();
}

class _MarksStatisticsState extends State<MarksStatistics> {
  late CalendarBloc calendarBloc;
  late FeedBloc feedBloc;
  Map<String, List<MarkedDateEvent>> eventsOrderByCategory = {};
  List<MarkedDateEvent> avalibleEvents = [];

  @override
  void initState() {
    calendarBloc = BlocProvider.of<CalendarBloc>(context, listen: false);
    feedBloc = BlocProvider.of<FeedBloc>(context, listen: false);
    /*  */

    super.initState();
  }

  List<MarkedDateEvent> getAvalibleEvents() {
    List<MarkedDateEvent> events = [];
    if (feedBloc.state.year != null) {
      events = calendarBloc.state.markedDays.where(
        (ev) {
          if (feedBloc.state.month == null) {
            if (ev.dateTime.year == feedBloc.state.year) {
              return true;
            }
          } else {
            if (ev.dateTime.year == feedBloc.state.year &&
                ev.dateTime.month == feedBloc.state.month! + 1) {
              return true;
            }
          }
          return false;
        },
      ).toList();
    } else {
      events = calendarBloc.state.markedDays;
    }
    return events;
  }

  Map<String, List<MarkedDateEvent>> getEventsOrderByCategory() {
    Map<String, List<MarkedDateEvent>> eventsByCategory = {};

    for (MarkedDateEvent date in avalibleEvents) {
      if (date.categoryName == null ||
          !calendarBloc.state.dateCategories.contains(date.categoryName)) {
        if (eventsByCategory['other'] == null) {
          eventsByCategory['other'] = [date];
          continue;
        }
        List<MarkedDateEvent> otherNewDateEventList =
            List.from(eventsByCategory['other']!)..add(date);
        eventsByCategory['other'] = otherNewDateEventList;
        continue;
      }

      if (eventsByCategory[date.categoryName!] == null) {
        eventsByCategory[date.categoryName!] = [date];
        continue;
      }
      List<MarkedDateEvent> newDateEventList =
          List.from(eventsByCategory[date.categoryName!]!)..add(date);
      eventsByCategory[date.categoryName!] = newDateEventList;
    }
    return eventsByCategory;
  }

  List<Widget> getCategoryEventsElements(List<MarkedDateEvent> events) {
    List<Widget> elements = [];
    Map<String, int> elementsByAmount = {};
    for (MarkedDateEvent event in events) {
      if (elementsByAmount[event.title] == null) {
        elementsByAmount[event.title] = 1;
      } else {
        elementsByAmount[event.title] = elementsByAmount[event.title]! + 1;
      }
    }
    elementsByAmount.forEach(
      (key, value) {
        elements.add(
          StatisticsEventElement(
            title: key,
            amount: value.toString(),
          ),
        );
      },
    );
    return elements;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          avalibleEvents = getAvalibleEvents();
          eventsOrderByCategory = getEventsOrderByCategory();
          return Wrap(
            runSpacing: 20,
            children: [
              for (String name in eventsOrderByCategory.keys)
                ExpansionTile(
                  title: Text(name),
                  subtitle: StatisticsTileSubtitle(
                    eventsOrderByCategory[name]!.length.toString(),
                  ),
                  expandedAlignment: Alignment.centerLeft,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      getCategoryEventsElements(eventsOrderByCategory[name]!),
                ),
            ],
          );
        },
      ),
    );
  }
}

class StatisticsTileSubtitle extends StatelessWidget {
  const StatisticsTileSubtitle(
    this.amount, {
    super.key,
  });

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Всего событый: $amount',
      style: const TextStyle(
        fontSize: 10,
      ),
    );
  }
}

class StatisticsEventElement extends StatelessWidget {
  const StatisticsEventElement({
    super.key,
    required this.title,
    required this.amount,
    this.titleHeight = 16,
  });

  final String title;
  final String amount;
  final double titleHeight;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleHeight,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: titleHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DatesFeed extends StatelessWidget {
  const DatesFeed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CalendarBloc calendarBloc = BlocProvider.of(context);
    FeedBloc feedBloc = BlocProvider.of(context);
    return SingleChildScrollView(
      child: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          List<MarkedDateEvent> getAvalibleEvents() {
            List<MarkedDateEvent> events = [];
            if (feedBloc.state.year != null) {
              events = calendarBloc.state.markedDays.where(
                (ev) {
                  if (feedBloc.state.month == null) {
                    if (ev.dateTime.year == feedBloc.state.year) {
                      return true;
                    }
                  } else {
                    if (ev.dateTime.year == feedBloc.state.year &&
                        ev.dateTime.month == feedBloc.state.month! + 1) {
                      return true;
                    }
                  }
                  return false;
                },
              ).toList();
            } else {
              events = calendarBloc.state.markedDays;
            }
            return events;
          }

          return Column(
            children: [
              for (MarkedDateEvent event in getAvalibleEvents())
                MarkedDateEventFeedItem(event),
            ],
          );
        },
      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () => Utils.platformNavigateTo(
          context: context,
          screen: DateEventScreen(event),
        ),
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
                        Utils.getDateString(event.dateTime),
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
                  if (event.description != null)
                    Text(
                      Utils.getShortDescription(event.description!),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
