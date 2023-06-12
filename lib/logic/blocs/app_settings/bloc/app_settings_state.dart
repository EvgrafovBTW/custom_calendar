// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'app_settings_bloc.dart';

class AppSettingsState extends Equatable {
  final Color primaryColor;
  final Color secondary;
  final Color tertiary;
  final Color onTertiary;
  final Color primaryColorDark;
  final Color secondaryDark;
  final bool isDarkMode;
  final bool firstLaunch;
  final String? name;
  final String? lastName;
  const AppSettingsState({
    this.primaryColor = const Color.fromRGBO(255, 120, 91, 1),
    this.secondary = const Color.fromARGB(255, 255, 193, 7),
    this.primaryColorDark = const Color(0xffbb86fc),
    this.secondaryDark = const Color(0xff03dac6),
    this.tertiary = const Color.fromRGBO(100, 28, 158, 1),
    this.onTertiary = const Color.fromRGBO(28, 158, 126, 1),
    this.isDarkMode = false,
    this.firstLaunch = false,
    this.name,
    this.lastName,
  });

  @override
  List<Object?> get props => [
        primaryColor,
        primaryColorDark,
        secondary,
        secondaryDark,
        isDarkMode,
        firstLaunch,
        tertiary,
        onTertiary,
        name,
        lastName,
      ];

  AppSettingsState copyWith({
    Color? primaryColor,
    Color? secondary,
    Color? tertiary,
    Color? onTertiary,
    Color? primaryColorDark,
    Color? secondaryDark,
    bool? isDarkMode,
    bool? firstLaunch,
    String? name,
    String? lastName,
  }) {
    return AppSettingsState(
      primaryColor: primaryColor ?? this.primaryColor,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      primaryColorDark: primaryColorDark ?? this.primaryColorDark,
      secondaryDark: secondaryDark ?? this.secondaryDark,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      firstLaunch: firstLaunch ?? this.firstLaunch,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'primaryColor': primaryColor.value,
      'secondary': secondary.value,
      'tertiary': tertiary.value,
      'onTertiary': onTertiary.value,
      'primaryColorDark': primaryColorDark.value,
      'secondaryDark': secondaryDark.value,
      'isDarkMode': isDarkMode,
      'firstLaunch': firstLaunch,
      'name': name,
      'lastName': lastName,
    };
  }

  factory AppSettingsState.fromMap(Map<String, dynamic> map) {
    return AppSettingsState(
      primaryColor: Color(map['primaryColor'] as int),
      secondary: Color(map['secondary'] as int),
      tertiary: Color(map['tertiary'] as int),
      onTertiary: Color(map['onTertiary'] as int),
      primaryColorDark: Color(map['primaryColorDark'] as int),
      secondaryDark: Color(map['secondaryDark'] as int),
      isDarkMode: map['isDarkMode'] as bool,
      firstLaunch: map['firstLaunch'] as bool,
      name: map['name'] != null ? map['name'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppSettingsState.fromJson(String source) =>
      AppSettingsState.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AppSettingsInitial extends AppSettingsState {}
