library mobichan_repository;

import 'package:mobichan_datasources/boards/datasources/board_local_datasource.dart';
import 'package:mobichan_datasources/boards/datasources/board_remote_datasource.dart';
import 'package:mobichan_datasources/boards/models/board.dart';

class BoardRepository {
  BoardRepository({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  final BoardRemoteDatasource remoteDatasource;
  final BoardLocalDatasource localDatasource;

  Future<List<Board>> search(String? searchTerm) async {
    List<Board> boards = await remoteDatasource.boards();

    if (searchTerm == null) {
      return boards;
    }

    return boards
        .where((board) =>
            _matchesSearchTerm(searchTerm, board.board) ||
            _matchesSearchTerm(searchTerm, board.title))
        .toList();
  }

  bool _matchesSearchTerm(String searchTerm, String? field) {
    if (field == null) {
      return false;
    }
    return field.toLowerCase().contains(searchTerm.toLowerCase());
  }
}
