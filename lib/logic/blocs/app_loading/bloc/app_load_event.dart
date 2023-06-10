part of 'app_load_bloc.dart';

abstract class AppLoadEvent extends Equatable {
  const AppLoadEvent();

  @override
  List<Object> get props => [];
}

class AppLoadStart extends AppLoadEvent {}

class AppLoadComplete extends AppLoadEvent {}
