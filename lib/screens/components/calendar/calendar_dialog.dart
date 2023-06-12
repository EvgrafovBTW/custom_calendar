import 'package:custom_calendar/logic/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:custom_calendar/logic/models/marked_date_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:overlay_support/overlay_support.dart';

class CalendarDialog extends StatefulWidget {
  const CalendarDialog(
    this.date, {
    super.key,
  });
  final DateTime date;

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late CalendarBloc calendarBloc;
  List<String> hints = [];
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    calendarBloc = BlocProvider.of<CalendarBloc>(context, listen: false);
    for (MarkedDateEvent date
        in calendarBloc.state.markedDays.reversed.take(10)) {
      if (!hints.contains(date.title)) {
        hints.add(date.title);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
      material: (context, platform) => MaterialAlertDialogData(),
      cupertino: (context, platform) => CupertinoAlertDialogData(),
      title: const Text('Отметить событие?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              calendarBloc.add(
                MarkNewDate(
                  MarkedDateEvent(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    dateTime: widget.date,
                    title: titleController.text,
                    description: descriptionController.text,
                  ),
                ),
              );
              Navigator.pop(context);
            } else {
              showSimpleNotification(const Text('Введите название события'));
            }
          },
          child: const Text('Сохранить'),
        ),
      ],
      content: SizedBox.fromSize(
        size: MediaQuery.of(context).size / 2,
        /*  child: const CalendarAutocomplete(), */
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20.0),
                    labelText: "Как назовём это событие?",
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(),
                    ),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2.7,
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                    children: [
                      for (String title in hints)
                        GestureDetector(
                          onTap: () => titleController.text = title,
                          child: DateNameHint(title),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: descriptionController,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20.0),
                    labelText: "Добавить описание",
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateNameHint extends StatelessWidget {
  const DateNameHint(
    this.name, {
    super.key,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(name),
      ),
    );
  }
}

class CalendarAutocomplete extends StatelessWidget {
  const CalendarAutocomplete({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RawAutocomplete(
          optionsViewBuilder: (
            context,
            void Function(String) onSelected,
            Iterable<String> options,
          ) {
            return Material(
              color: Colors.transparent,
              child: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: options.map((opt) {
                      return Card(
                        child: InkWell(
                          onTap: () {
                            onSelected(opt);
                          },
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 100,
                              maxWidth: 200,
                            ),
                            child: Text(opt),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return <String>[];
            }
            return <String>[
              '[eq]',
              '[eq]',
              '[eq]',
              '[eq]',
              '[eq]',
              '[eq]',
              '[eq]',
              '[eq]',
              '[eq]',
              '[eq]',
              '[eq]',
              '[eq]',
              '[eq]',
            ];
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              controller: textEditingController,
              focusNode: focusNode,
              onSubmitted: (String value) {},
            );
          },
        )
      ],
    );
  }
}
