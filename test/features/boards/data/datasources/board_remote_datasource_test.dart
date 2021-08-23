import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobichan/features/boards/data/datasources/board_remote_datasource.dart';
import 'package:mobichan/features/boards/data/models/board.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockBoardRemoteDatasource extends BoardRemoteDatasource implements Mock {
  MockBoardRemoteDatasource(
      {required http.Client httpClient, required JsonCodec jsonCodec})
      : super(httpClient: httpClient, jsonCodec: jsonCodec);
}

class MockHttpClient extends Mock implements http.Client {}

class MockJsonCodec extends Mock implements JsonCodec {}

void main() {
  late BoardRemoteDatasource datasource;
  late http.Client httpClient;
  late JsonCodec jsonCodec;

  setUp(() {
    registerFallbackValue(Uri());

    httpClient = MockHttpClient();
    jsonCodec = MockJsonCodec();
    datasource = MockBoardRemoteDatasource(
      httpClient: httpClient,
      jsonCodec: jsonCodec,
    );
  });

  group('boards', () {
    test(
      'should throw an HttpException when the GET request is unsuccessful',
      () {
        when(() => httpClient.get(any())).thenThrow(Exception());
        expect(() => datasource.boards(), throwsA(isA<HttpException>()));
      },
    );
    test(
      'should throw an HttpRequestFailure when the response code is not 200',
      () {
        when(() => httpClient.get(any()))
            .thenAnswer((_) async => http.Response("Error", 404));
        expect(() => datasource.boards(), throwsA(isA<HttpRequestFailure>()));
      },
    );
    test(
      'should throw a JsonDecodeException when decoding the response is unsuccessful',
      () {
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response(fixture('boards.json'), 200),
        );
        when(() => jsonCodec.decode(any())).thenThrow(Exception());
        expect(() => datasource.boards(), throwsA(isA<JsonDecodeException>()));
      },
    );
    test(
      'should return a list of boards',
      () async {
        when(() => httpClient.get(any())).thenAnswer(
          (_) async => http.Response(fixture('boards.json'), 200),
        );
        when(() => jsonCodec.decode(any()))
            .thenReturn(json.decode(fixture('boards.json')));

        final boards = await datasource.boards();
        final expectedBoards =
            (json.decode(fixture('boards.json'))["boards"] as List)
                .map((e) => Board.fromJson(e))
                .toList();

        expect(boards, equals(expectedBoards));
      },
    );
  });
}
