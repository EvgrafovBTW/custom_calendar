import 'package:custom_calendar/screens/components/profile/user_change_name_dialog.dart';
import 'package:custom_calendar/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../logic/blocs/app_settings/bloc/app_settings_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double sHeight = MediaQuery.of(context).size.height;
    AppSettingsBloc appSettingsBloc = BlocProvider.of<AppSettingsBloc>(context);
    TextStyle settingLabelStyle = TextStyle(fontSize: sHeight * 0.03);

    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        return Scaffold(
          body: SizedBox.expand(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                child: Column(
                  children: [
                    UserWelcome(state),
                    Divider(color: state.primaryColor),
                    Wrap(
                      runSpacing: 40,
                      children: [
                        /*  Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Ночной режим',
                              style: settingLabelStyle,
                            ),
                            PlatformSwitch(
                              value: state.isDarkMode,
                              onChanged: (v) {
                                appSettingsBloc.add(ToggleDarkMode(v));
                              },
                            )
                          ],
                        ), */
                        GestureDetector(
                          onTap: () {
                            showPlatformModalSheet(
                              context: context,
                              builder: (context) => MainColorChangeSheet(
                                  appSettingsBloc: appSettingsBloc),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Основной цвет',
                                style: settingLabelStyle,
                              ),
                              SettingsColorPane(
                                side: sHeight * 0.05,
                                color: state.isDarkMode
                                    ? state.primaryColorDark
                                    : state.primaryColor,
                                isDarkMode: state.isDarkMode,
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showPlatformModalSheet(
                              context: context,
                              builder: (context) => AdditionalColorChangeSheet(
                                  appSettingsBloc: appSettingsBloc),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Дополнительный цвет',
                                        style: settingLabelStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SettingsColorPane(
                                side: sHeight * 0.05,
                                color: state.isDarkMode
                                    ? state.secondaryDark
                                    : state.secondary,
                                isDarkMode: state.isDarkMode,
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showPlatformModalSheet(
                              context: context,
                              builder: (context) => TeritaryColorChangeSheet(
                                  appSettingsBloc: appSettingsBloc),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Третичный цвет',
                                        style: settingLabelStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SettingsColorPane(
                                side: sHeight * 0.05,
                                color:
                                    // state.isDarkMode
                                    //     ? state.secondaryDark
                                    //     :
                                    state.tertiary,
                                isDarkMode: state.isDarkMode,
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showPlatformModalSheet(
                              context: context,
                              builder: (context) => OnTeritaryColorChangeSheet(
                                  appSettingsBloc: appSettingsBloc),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Цвет поверх третичного',
                                        style: settingLabelStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SettingsColorPane(
                                side: sHeight * 0.05,
                                color:
                                    //  state.isDarkMode
                                    //     ? state.secondaryDark
                                    //     :
                                    state.onTertiary,
                                isDarkMode: state.isDarkMode,
                              )
                            ],
                          ),
                        ),
                        /*  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Анимации',
                              style: settingLabelStyle,
                            ),
                            PlatformSwitch(
                              value: state.firstLaunch,
                              onChanged: (v) {
                                appSettingsBloc.add(ToggleAnimationUse(v));
                              },
                            )
                          ],
                        ), */
                        /*
                        ChangeNameSheet(
                          isDarkMode: state.isDarkMode,
                          // nameController: nameController,
                          // lastNameController: lastNameController,
                        )*/
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class UserWelcome extends StatelessWidget {
  const UserWelcome(
    this.state, {
    super.key,
  });
  final AppSettingsState state;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPlatformDialog(
          context: context,
          material: MaterialDialogData(),
          builder: (context) {
            return const UserChangeNameDialog();
          },
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Добрый день,',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.025,
              color: state.tertiary,
            ),
          ),
          if (state.name != null && state.lastName != null)
            Text(
              '${state.name} ${state.lastName}',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.030,
                color: state.primaryColor,
              ),
            ),
          if (state.name == null || state.lastName == null)
            Text(
              'Пользователь',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.030,
                color: state.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          Text(
            'Чтобы изменить имя пользователя, нажмите на текущее имя',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.015,
              color: state.onTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class MainColorChangeSheet extends StatelessWidget {
  const MainColorChangeSheet({
    super.key,
    required this.appSettingsBloc,
  });

  final AppSettingsBloc appSettingsBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*  Row(
                    children: [
                      const Text('Ночной режим'),
                      PlatformSwitch(
                        value: state.isDarkMode,
                        onChanged: (v) {
                          appSettingsBloc.add(ToggleDarkMode(v));
                        },
                      ),
                    ],
                  ), */
                  PlatformTextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Закрыть'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SettingsColorChoosePanel(
                isDarkMode: state.isDarkMode,
              ),
            ),
          ],
        );
      },
    );
  }
}

class AdditionalColorChangeSheet extends StatelessWidget {
  const AdditionalColorChangeSheet({
    super.key,
    required this.appSettingsBloc,
  });

  final AppSettingsBloc appSettingsBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*  Row(
                    children: [
                      const Text('Ночной режим'),
                      PlatformSwitch(
                        value: state.isDarkMode,
                        onChanged: (v) {
                          appSettingsBloc.add(ToggleDarkMode(v));
                        },
                      ),
                    ],
                  ), */
                  PlatformTextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Закрыть'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SettingsColorChoosePanel(
                isDarkMode: state.isDarkMode,
                mode: ChangeColorMode.additional,
              ),
            ),
          ],
        );
      },
    );
  }
}

class TeritaryColorChangeSheet extends StatelessWidget {
  const TeritaryColorChangeSheet({
    super.key,
    required this.appSettingsBloc,
  });

  final AppSettingsBloc appSettingsBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*  Row(
                    children: [
                      const Text('Ночной режим'),
                      PlatformSwitch(
                        value: state.isDarkMode,
                        onChanged: (v) {
                          appSettingsBloc.add(ToggleDarkMode(v));
                        },
                      ),
                    ],
                  ), */
                  PlatformTextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Закрыть'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SettingsColorChoosePanel(
                isDarkMode: state.isDarkMode,
                mode: ChangeColorMode.teritary,
              ),
            ),
          ],
        );
      },
    );
  }
}

class OnTeritaryColorChangeSheet extends StatelessWidget {
  const OnTeritaryColorChangeSheet({
    super.key,
    required this.appSettingsBloc,
  });

  final AppSettingsBloc appSettingsBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*  Row(
                    children: [
                      const Text('Ночной режим'),
                      PlatformSwitch(
                        value: state.isDarkMode,
                        onChanged: (v) {
                          appSettingsBloc.add(ToggleDarkMode(v));
                        },
                      ),
                    ],
                  ), */
                  PlatformTextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Закрыть'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SettingsColorChoosePanel(
                isDarkMode: state.isDarkMode,
                mode: ChangeColorMode.onTeritary,
              ),
            ),
          ],
        );
      },
    );
  }
}

class SettingsColorChoosePanel extends StatelessWidget {
  final Widget? example;
  final ChangeColorMode mode;
  final bool isDarkMode;

  const SettingsColorChoosePanel({
    required this.isDarkMode,
    this.mode = ChangeColorMode.main,
    this.example,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void applyChoosenColor(Color color) {
      if (mode == ChangeColorMode.main) {
        BlocProvider.of<AppSettingsBloc>(context).add(
          isDarkMode
              ? ChangeMainAppColorDark(color)
              : ChangeMainAppColor(color),
        );
      }
      if (mode == ChangeColorMode.additional) {
        BlocProvider.of<AppSettingsBloc>(context).add(
          isDarkMode
              ? ChangeAdditionalAppColorDark(color)
              : ChangeAdditionalAppColor(color),
        );
      }
      if (mode == ChangeColorMode.teritary) {
        BlocProvider.of<AppSettingsBloc>(context).add(
          // isDarkMode
          //     ? ChangeAdditionalAppColorDark(color)
          //     :
          ChangeTeritaryAppColor(color),
        );
      }
      if (mode == ChangeColorMode.onTeritary) {
        BlocProvider.of<AppSettingsBloc>(context).add(
          // isDarkMode
          //     ? ChangeAdditionalAppColorDark(color)
          //     :
          ChangeOnTeritaryAppColor(color),
        );
      }
    }

    return Column(
      children: [
        if (example != null) example!,
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  children: [
                    for (var color in Decorations.settingsColors)
                      GestureDetector(
                        onTap: () {
                          applyChoosenColor(color);
                        },
                        child: SettingsColorPane(
                          color: color,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsColorPane extends StatelessWidget {
  final bool isDarkMode;
  final Color color;
  final double side;

  const SettingsColorPane({
    super.key,
    this.side = 50,
    required this.color,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: side,
      height: side,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: isDarkMode ? Colors.white54 : Colors.black54,
        ),
      ),
    );
  }
}

enum ChangeColorMode { main, additional, teritary, onTeritary }
