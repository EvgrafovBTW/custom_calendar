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
  TextEditingController categoryNameController = TextEditingController();
  late CalendarBloc calendarBloc;
  List<String> hints = [];
  ValueNotifier<String> categoryValue = ValueNotifier('');
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryNameController.dispose();
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

      categoryNameController.addListener(() {
        categoryValue.value = categoryNameController.text.trim();
      });
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
                    categoryName: categoryNameController.text,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '* - Обязательное поле',
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20.0),
                    labelText: "Как назовём это событие?*",
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(),
                    ),
                  ),
                ),
              ),
              DateNameHelper(
                hints: hints,
                titleController: titleController,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: CategoryNameStatusIndicator(
                  categoryValue: categoryValue,
                  calendarBloc: calendarBloc,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: categoryNameController,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20.0),
                    labelText: "Определить в категорию:",
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(),
                    ),
                  ),
                ),
              ),
              CategoryNameHint(
                calendarBloc: calendarBloc,
                categoryNameController: categoryNameController,
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

class CategoryNameHint extends StatelessWidget {
  const CategoryNameHint({
    super.key,
    required this.calendarBloc,
    required this.categoryNameController,
  });

  final CalendarBloc calendarBloc;
  final TextEditingController categoryNameController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 2.7,
      ),
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            for (String categoryName in calendarBloc.state.dateCategories)
              GestureDetector(
                onTap: () => categoryNameController.text = categoryName,
                child: NameHint(categoryName),
              ),
          ],
        ),
      ),
    );
  }
}

class CategoryNameStatusIndicator extends StatelessWidget {
  const CategoryNameStatusIndicator({
    super.key,
    required this.categoryValue,
    required this.calendarBloc,
  });

  final ValueNotifier<String> categoryValue;
  final CalendarBloc calendarBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ValueListenableBuilder(
        valueListenable: categoryValue,
        builder: (context, value, child) {
          if (categoryValue.value.isEmpty) {
            return const SizedBox();
          }
          if (calendarBloc.state.dateCategories.contains(value)) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Выбрана существующая категория',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: MediaQuery.of(context).size.height * 0.015,
                ),
                overflow: TextOverflow.clip,
              ),
            );
          }
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Будет добавлена новая категория',
              style: TextStyle(
                color: Colors.amber,
                fontSize: MediaQuery.of(context).size.height * 0.015,
              ),
              overflow: TextOverflow.clip,
            ),
          );
        },
      ),
    );
  }
}

class DateNameHelper extends StatelessWidget {
  const DateNameHelper({
    super.key,
    required this.hints,
    required this.titleController,
  });

  final List<String> hints;
  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 2.7,
      ),
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            for (String title in hints)
              GestureDetector(
                onTap: () => titleController.text = title,
                child: NameHint(title),
              ),
          ],
        ),
      ),
    );
  }
}

class NameHint extends StatelessWidget {
  const NameHint(
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
/* 
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
 */