import 'dart:convert';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;


abstract class NumberTriviaRemoteDataSource {
  /// call the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getStaticNumberTrivia(int number);

  /// call the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

Uri url(String extension) =>
    Uri(scheme: 'http', host: 'numbersapi.com', query: extension);

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({required this.client});
  @override
  Future<NumberTriviaModel> getStaticNumberTrivia(int number) {
    return _getTriviaFromUrl(url('$number'));
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getTriviaFromUrl(url('random'));
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(Uri url) async {
    final response =
        await client.get(url, headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    if (response.statusCode == 200) {
      print(response.body);
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }
    throw ServerException();
  }
}

