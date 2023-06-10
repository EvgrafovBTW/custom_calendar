import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_load_event.dart';
part 'app_load_state.dart';

class AppLoadBloc extends Bloc<AppLoadEvent, AppLoadState> {
  AppLoadBloc() : super(AppLoadInitial()) {
    on<AppLoadStart>((event, emit) => emit(AppLoading()));
    on<AppLoadComplete>((event, emit) => emit(AppLoaded()));
  }
}
