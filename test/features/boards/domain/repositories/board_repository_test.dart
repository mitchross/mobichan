import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan/features/boards/data/datasources/board_local_datasource.dart';
import 'package:mobichan/features/boards/data/datasources/board_remote_datasource.dart';
import 'package:mobichan/features/boards/data/models/board.dart';
import 'package:mobichan/features/boards/domain/repositories/board_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

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
      remoteDatasource: remoteDatasource,
      localDatasource: localDatasource,
    );
  });

  group('search', () {
    final tBoards = (json.decode(fixture('boards.json'))["boards"] as List)
        .map((e) => Board.fromJson(e))
        .toList();
    final tSearchTerm = "technology";
    final tBoardCode = "g";

    test(
      'should return all boards when no search term is passed',
      () async {
        when(() => remoteDatasource.boards()).thenAnswer((_) async => tBoards);

        final boards = await repository.search();

        expect(boards, equals(tBoards));
      },
    );
    test(
      'should return a subset of boards when a search term is passed as an argument',
      () async {
        when(() => remoteDatasource.boards()).thenAnswer((_) async => tBoards);

        final boards = await repository.search(searchTerm: tSearchTerm);

        final expectedBoards =
            tBoards.where((board) => board.board == tBoardCode).toList();

        expect(boards, equals(expectedBoards));
      },
    );
  });
}
