import 'dart:convert';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  //
  Future<NumberTriviaModel> getStaticNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

Uri url(String url){
    return Uri(scheme: 'http',host: 'numbersapi.com', query: url);
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;


  @override
  Future<NumberTriviaModel> getStaticNumberTrivia(int number)  {
    return _getTriviaFromUrl(url("$number"));
  }

  NumberTriviaRemoteDataSourceImpl({required this.client});
  @override
  Future<NumberTriviaModel> getRandomNumberTrivia()  {
    return _getTriviaFromUrl(url('random'));
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(Uri url) async {
    final response = await client.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } 
    throw ServerException();
    
  }
}
