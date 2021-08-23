part of 'board_bloc.dart';

enum BoardStatus { initial, loading, success, failure }

class BoardState extends Equatable {
  const BoardState._({
    this.status = BoardStatus.initial,
    this.boards = const <Board>[],
  });

  const BoardState.initial() : this._();

  const BoardState.loading() : this._(status: BoardStatus.loading);

  const BoardState.success(List<Board> boards)
      : this._(status: BoardStatus.success, boards: boards);

  const BoardState.failure() : this._(status: BoardStatus.failure);

  final BoardStatus status;
  final List<Board> boards;

  @override
  List<Object> get props => [status, boards];
}
