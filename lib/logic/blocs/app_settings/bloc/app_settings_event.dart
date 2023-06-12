part of 'app_settings_bloc.dart';

abstract class AppSettingsEvent extends Equatable {
  const AppSettingsEvent();

  @override
  List<Object> get props => [];
}

class ChangeMainAppColor extends AppSettingsEvent {
  final Color newMainColor;
  const ChangeMainAppColor(this.newMainColor);
}

class ChangeAdditionalAppColor extends AppSettingsEvent {
  final Color newAdditionalColor;
  const ChangeAdditionalAppColor(this.newAdditionalColor);
}

class ChangeTeritaryAppColor extends AppSettingsEvent {
  final Color newTeritaryColor;
  const ChangeTeritaryAppColor(this.newTeritaryColor);
}

class ChangeOnTeritaryAppColor extends AppSettingsEvent {
  final Color newOnTeritaryColor;
  const ChangeOnTeritaryAppColor(this.newOnTeritaryColor);
}

class ChangeMainAppColorDark extends AppSettingsEvent {
  final Color newMainColorDark;
  const ChangeMainAppColorDark(this.newMainColorDark);
}

class ChangeAdditionalAppColorDark extends AppSettingsEvent {
  final Color newAdditionalColorDark;
  const ChangeAdditionalAppColorDark(this.newAdditionalColorDark);
}

class ToggleDarkMode extends AppSettingsEvent {
  final bool darkModeValue;
  const ToggleDarkMode(this.darkModeValue);
}

class ToggleAnimationUse extends AppSettingsEvent {
  final bool animationUseValue;
  const ToggleAnimationUse(this.animationUseValue);
}

class ChangeUserName extends AppSettingsEvent {
  final String? name;
  final String? lastName;
  const ChangeUserName({
    this.name,
    this.lastName,
  });
}
