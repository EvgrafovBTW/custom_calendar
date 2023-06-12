import 'package:custom_calendar/logic/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:custom_calendar/logic/models/marked_date_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CalendarDialog extends StatelessWidget {
  const CalendarDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    CalendarBloc calendarBloc = BlocProvider.of<CalendarBloc>(context);
    return PlatformAlertDialog(
      material: (context, platform) => MaterialAlertDialogData(),
      cupertino: (context, platform) => CupertinoAlertDialogData(),
      title: const Text('Отметить день?'),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('Сохранить'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
      ],
      content: SizedBox.fromSize(
        size: MediaQuery.of(context).size / 2,
        /*  child: const CalendarAutocomplete(), */
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20.0),
                  labelText: "Как назовём этот день?",
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
                    for (MarkedDateEvent date in calendarBloc.state.markedDays)
                      GestureDetector(
                        onTap: () => controller.text = date.title,
                        child: DateNameHint(date.title),
                      ),
                  ],
                ),
              ),
            )
          ],
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
      child: Text(name),
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
