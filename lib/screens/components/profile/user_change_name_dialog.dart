import 'package:custom_calendar/logic/blocs/app_settings/bloc/app_settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class UserChangeNameDialog extends StatefulWidget {
  const UserChangeNameDialog({super.key});

  @override
  State<UserChangeNameDialog> createState() => _UserChangeNameDialogState();
}

class _UserChangeNameDialogState extends State<UserChangeNameDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  late AppSettingsBloc settingsBloc;
  List<String> hints = [];
  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    settingsBloc = BlocProvider.of<AppSettingsBloc>(context, listen: false);
    if (settingsBloc.state.name != null) {
      nameController.text = settingsBloc.state.name!;
    }
    if (settingsBloc.state.lastName != null) {
      lastNameController.text = settingsBloc.state.lastName!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
      material: (context, platform) => MaterialAlertDialogData(),
      cupertino: (context, platform) => CupertinoAlertDialogData(),
      title: const Text('Новое имя пользователя'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            settingsBloc.add(
              ChangeUserName(
                name: nameController.text,
                lastName: lastNameController.text,
              ),
            );
            Navigator.pop(context);
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
                  controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20.0),
                    labelText: "Ваше имя",
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: lastNameController,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20.0),
                    labelText: "Ваша фамилия",
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
