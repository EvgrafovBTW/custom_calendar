// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bottom_navigation_bloc.dart';

// ignore: must_be_immutable
class BottomNavigationState extends Equatable {
  int pageIndex;
  BottomNavigationState({this.pageIndex = 0});

  @override
  List<Object> get props => [pageIndex];

  BottomNavigationState copyWith({
    int? pageIndex,
  }) {
    return BottomNavigationState(
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }
}
