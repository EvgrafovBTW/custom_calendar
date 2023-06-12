import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends HydratedBloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc() : super(AppSettingsInitial()) {
    on<ChangeMainAppColor>(
      (event, emit) => emit(state.copyWith(primaryColor: event.newMainColor)),
    );
    on<ChangeAdditionalAppColor>(
      (event, emit) =>
          emit(state.copyWith(secondary: event.newAdditionalColor)),
    );
    on<ChangeMainAppColorDark>(
      (event, emit) =>
          emit(state.copyWith(primaryColorDark: event.newMainColorDark)),
    );
    on<ChangeAdditionalAppColorDark>(
      (event, emit) =>
          emit(state.copyWith(secondaryDark: event.newAdditionalColorDark)),
    );
    on<ToggleDarkMode>(
      (event, emit) => emit(
        state.copyWith(
          isDarkMode: event.darkModeValue,
        ),
      ),
    );
    on<ToggleAnimationUse>(
      (event, emit) => emit(
        state.copyWith(
          firstLaunch: event.animationUseValue,
        ),
      ),
    );
    on<ChangeTeritaryAppColor>(
      (event, emit) => emit(state.copyWith(tertiary: event.newTeritaryColor)),
    );
    on<ChangeOnTeritaryAppColor>(
      (event, emit) =>
          emit(state.copyWith(onTertiary: event.newOnTeritaryColor)),
    );
    on<ChangeUserName>(
      (event, emit) => emit(
        state.copyWith(
          name: event.name,
          lastName: event.lastName,
        ),
      ),
    );
  }

  @override
  AppSettingsState? fromJson(Map<String, dynamic> json) =>
      AppSettingsState.fromMap(json);

  @override
  Map<String, dynamic>? toJson(AppSettingsState state) => state.toMap();
}
