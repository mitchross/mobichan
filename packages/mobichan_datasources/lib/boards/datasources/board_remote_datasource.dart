library mobichan_datasources;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobichan_datasources/boards/models/board.dart';

const String BOARDS_URL = "https://a.4cdn.org/boards.json";

/// Thrown if an exception occurs while making an `http` request.
class HttpException implements Exception {}

/// Thrown if an `http` request returns a non-200 status code.
class HttpRequestFailure implements Exception {
  const HttpRequestFailure(this.statusCode);

  final int statusCode;
}

/// Thrown if an excepton occurs while decoding the response body.
class JsonDecodeException implements Exception {}

/// Thrown is an error occurs while deserializing the response body.
class JsonDeserializationException implements Exception {}

class BoardRemoteDatasource {
  BoardRemoteDatasource({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  /// Fetches a list of all boards from the https://a.4cdn.org/boards.json endpoint.
  ///
  /// Returns a list of [Board] models.
  Future<List<Board>> boards() async {
    http.Response response;

    try {
      response = await _httpClient.get(Uri.parse(BOARDS_URL));
    } on Exception {
      throw HttpException();
    }

    if (response.statusCode != 200) {
      throw HttpRequestFailure(response.statusCode);
    }

    List boards;

    try {
      boards = json.decode(response.body)["boards"] as List;
    } on Exception {
      throw JsonDecodeException();
    }

    try {
      return boards
          .map((dynamic item) => Board.fromJson(item as Map<String, dynamic>))
          .toList();
    } on Exception {
      throw JsonDeserializationException();
    }
  }
}
