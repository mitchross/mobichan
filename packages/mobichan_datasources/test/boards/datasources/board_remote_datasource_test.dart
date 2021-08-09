import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobichan_datasources/boards/datasources/board_remote_datasource.dart';
import 'package:mobichan_datasources/boards/models/board.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_reader.dart';

class MockBoardRemoteDatasource extends BoardRemoteDatasource implements Mock {
  MockBoardRemoteDatasource({required http.Client httpClient})
      : super(httpClient: httpClient);
}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late BoardRemoteDatasource datasource;
  late http.Client httpClient;

  setUp(() {
    httpClient = MockHttpClient();
    datasource = MockBoardRemoteDatasource(httpClient: httpClient);
    registerFallbackValue(Uri());
  });

  group('boards', () {
    test(
      'should throw an HttpException when the GET request is unsuccessful',
      () {
        when(() => httpClient.get(any())).thenThrow(Exception());
        expect(() => datasource.boards(null), throwsA(isA<HttpException>()));
      },
    );
    test(
      'should throw an HttpRequestFailure when the response code is not 200',
      () {
        when(() => httpClient.get(any()))
            .thenAnswer((_) async => http.Response("Error", 404));
        expect(
            () => datasource.boards(null), throwsA(isA<HttpRequestFailure>()));
      },
    );
    test(
      'should return all boards when no arguments are passed',
      () async {
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response(fixture('boards.json'), 200),
        );

        final boards = await datasource.boards(null);
        final expectedBoards =
            (json.decode(fixture('boards.json'))["boards"] as List)
                .map((e) => Board.fromJson(e))
                .toList();

        expect(boards, equals(expectedBoards));
      },
    );
    test(
      'should return a subset of boards when a search term is passed as an argument',
      () async {
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response(fixture('boards.json'), 200),
        );

        final boards = await datasource.boards("technology");
        final expectedBoards =
            (json.decode(fixture('boards.json'))["boards"] as List)
                .map((e) => Board.fromJson(e))
                .where((board) => board.board == "g")
                .toList();

        expect(boards, equals(expectedBoards));
      },
    );
  });
}
