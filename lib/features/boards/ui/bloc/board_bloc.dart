import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobichan/features/boards/data/models/board.dart';
import 'package:mobichan/features/boards/domain/repositories/board_repository.dart';

part 'board_event.dart';
part 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc(this._boardRepository) : super(BoardState.initial());

  final BoardRepository _boardRepository;

  @override
  Stream<BoardState> mapEventToState(
    BoardEvent event,
  ) async* {
    if (event is SearchTermChanged) {
      yield* _mapSearchTermChangedToState(event, state);
    }
  }

  Stream<BoardState> _mapSearchTermChangedToState(
    SearchTermChanged event,
    BoardState state,
  ) async* {
    if (event.term.isEmpty) {
      yield const BoardState.initial();
      return;
    }

    if (state.status != BoardStatus.success) {
      print("loading");
      yield const BoardState.loading();
    }

    try {
      final boards = await _boardRepository.search(searchTerm: event.term);
      print("success");
      yield BoardState.success(boards);
    } on Exception {
      yield const BoardState.failure();
    }
  }
}
