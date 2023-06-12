part of 'app_load_bloc.dart';

abstract class AppLoadState extends Equatable {
  const AppLoadState();

  @override
  List<Object> get props => [];
}

class AppLoadInitial extends AppLoadState {}

class AppLoading extends AppLoadState {}

class AppOnboarding extends AppLoadState {}

class AppLoaded extends AppLoadState {}
