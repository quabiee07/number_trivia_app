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



class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({required this.client});
  @override
  Future<NumberTriviaModel> getStaticNumberTrivia(int number) {
    return _getTriviaFromUrl('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getTriviaFromUrl('http://numbersapi.com/random');
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response =
        await client.get(
          Uri.parse(url), 
          headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      print(response.body);
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }
    throw ServerException();
  }
}

