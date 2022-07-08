import 'package:number_trivia/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/domain/use_cases/get_random_number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {

  //
  Future<NumberTriviaModel> getStaticNumberTrivia(int number);


  Future<NumberTriviaModel> getRandomNumberTrivia();
  

}