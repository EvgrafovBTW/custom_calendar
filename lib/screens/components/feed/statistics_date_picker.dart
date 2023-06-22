import 'package:custom_calendar/logic/blocs/feed_bloc/bloc/feed_bloc.dart';
import 'package:custom_calendar/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:overlay_support/overlay_support.dart';

class StatisticsDatePicker extends StatefulWidget {
  const StatisticsDatePicker({
    super.key,
  });

  @override
  State<StatisticsDatePicker> createState() => _StatisticsDatePickerState();
}

class _StatisticsDatePickerState extends State<StatisticsDatePicker> {
  FocusNode textFieldFocusNode = FocusNode();
  TextEditingController yearInputController = TextEditingController();
  ScrollController monthScrollController = ScrollController();
  late FeedBloc feedBloc;

  ValueNotifier<int?> choosenMonthId = ValueNotifier(null);

  void onYearEditingComplete() {
    if (yearInputController.text.isNotEmpty) {
      feedBloc.add(UpdateYear(int.parse(yearInputController.text)));
      feedBloc.add(const SwithYearInput(false));
    } else {
      showSimpleNotification(const Text('Введите корретный год'));
    }
  }

  @override
  void initState() {
    feedBloc = BlocProvider.of<FeedBloc>(context);
    if (feedBloc.state.month != null) {
      choosenMonthId.value = feedBloc.state.month;
      //TODO добавть карту ключей для месяцев, чтобы централизировать выбранный месяц
    } else {
      Future.delayed(const Duration(milliseconds: 300)).whenComplete(
        () {
          monthScrollController
              .animateTo(
                30,
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
              )
              .whenComplete(
                () => monthScrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.linear,
                ),
              );
        },
      );
    }
    if (feedBloc.state.year != null) {
      yearInputController.text = feedBloc.state.year.toString();
    }

    super.initState();
  }

  @override
  void dispose() {
    choosenMonthId.dispose();
    yearInputController.dispose();
    monthScrollController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: const [
        GestureType.onTap,
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Wrap(
                children: [
                  Text(
                    'Выберите месяц для отображения статистики',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.035,
                    ),
                  ),
                ],
              ),
            ),
            const StatisticsDatePickerTitle('Будет выбран год:'),
            BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                return AnimatedCrossFade(
                  firstChild: GestureDetector(
                    onTap: () async {
                      feedBloc.add(const SwithYearInput(true));
                      await Future.delayed(const Duration(milliseconds: 300));
                      textFieldFocusNode.requestFocus();
                    },
                    child: YearInputResult(state.year),
                  ),
                  secondChild: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: yearInputController,
                          focusNode: textFieldFocusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onEditingComplete: onYearEditingComplete,
                        ),
                      ),
                      IconButton(
                        onPressed: onYearEditingComplete,
                        icon: Icon(
                          Icons.done,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                  crossFadeState: state.inputSwithcher
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: StatisticsDatePickerTitle('Будет выбран месяц:'),
            ),
            SingleChildScrollView(
              controller: monthScrollController,
              scrollDirection: Axis.horizontal,
              child: ValueListenableBuilder(
                valueListenable: choosenMonthId,
                builder: (context, value, child) {
                  return Wrap(
                    children: [
                      for (int i = 0; i < DateTime.monthsPerYear; i++)
                        GestureDetector(
                          onTap: () {
                            if (choosenMonthId.value != i) {
                              feedBloc.add(UpdateMonth(i));
                              choosenMonthId.value = i;
                            } else {
                              feedBloc.add(const UpdateMonth(null));
                              choosenMonthId.value = null;
                            }
                          },
                          child: StatisticsDatePickerMonthName(
                            Utils.monthsById[i]!,
                            choosen: choosenMonthId.value != null
                                ? choosenMonthId.value == i
                                : false,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      if (yearInputController.text.isNotEmpty) {
                        Navigator.pop(context);
                      } else {
                        showSimpleNotification(
                          const Text(
                            'Выберите год для отображения статистики',
                          ),
                        );
                      }
                    },
                    child: const Text('Применить'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticsDatePickerMonthName extends StatelessWidget {
  const StatisticsDatePickerMonthName(
    this.name, {
    super.key,
    this.choosen = false,
  });

  final String name;
  final bool choosen;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: choosen ? Theme.of(context).primaryColor : null,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(name),
      ),
    );
  }
}

class StatisticsDatePickerTitle extends StatelessWidget {
  const StatisticsDatePickerTitle(
    this.title, {
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.02,
          ),
        ),
      ],
    );
  }
}

class YearInputResult extends StatelessWidget {
  const YearInputResult(
    this.year, {
    super.key,
  });

  final int? year;

  @override
  Widget build(BuildContext context) {
    FeedBloc feedBloc = BlocProvider.of<FeedBloc>(context);
    if (year != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    year.toString(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'Нажмите, чтобы изменить год',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.015,
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              feedBloc.add(const UpdateYear(null));
            },
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Нажмите, чтобы изменить год',
              ),
            ),
          ),
        ],
      );
    }
  }
}
