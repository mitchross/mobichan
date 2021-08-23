part of 'board_bloc.dart';

abstract class BoardEvent extends Equatable {
  const BoardEvent();
}

class SearchTermChanged extends BoardEvent {
  const SearchTermChanged(this.term);

  final String term;

  @override
  List<Object> get props => [term];
}
