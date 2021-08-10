import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan_datasources/boards/datasources/board_local_datasource.dart';
import 'package:mobichan_datasources/boards/datasources/board_remote_datasource.dart';
import 'package:mobichan_datasources/boards/models/board.dart';
import 'package:mobichan_repositories/boards/board_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../fixtures/fixture_reader.dart';

class MockRemoteDatasource extends Mock implements BoardRemoteDatasource {}

class MockLocalDatasource extends Mock implements BoardLocalDatasource {}

void main() {
  late BoardRemoteDatasource remoteDatasource;
  late BoardLocalDatasource localDatasource;
  late BoardRepository repository;

  setUp(() {
    remoteDatasource = MockRemoteDatasource();
    localDatasource = MockLocalDatasource();

    repository = BoardRepository(
        remoteDatasource: remoteDatasource, localDatasource: localDatasource);
  });

  group('search', () {
    final tBoards = (json.decode(fixture('boards.json'))["boards"] as List)
        .map((e) => Board.fromJson(e))
        .toList();
    final tSearchTerm = "technology";
    final tBoardCode = "g";

    test(
      'should return all boards when the search term is null',
      () async {
        when(() => remoteDatasource.boards()).thenAnswer((_) async => tBoards);

        final boards = await repository.search(null);

        expect(boards, equals(tBoards));
      },
    );
    test(
      'should return a subset of boards when a search term is passed as an argument',
      () async {
        when(() => remoteDatasource.boards()).thenAnswer((_) async => tBoards);

        final boards = await repository.search(tSearchTerm);

        final expectedBoards =
            tBoards.where((board) => board.board == tBoardCode).toList();

        expect(boards, equals(expectedBoards));
      },
    );
  });
}
