import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/feature/number_trivia/data/data_src/number_trivia_local_data_source.dart';
import 'package:number_trivia/feature/number_trivia/data/data_src/number_trivia_remote_data_source.dart';
import 'package:number_trivia/feature/number_trivia/domain/repositories/number_trivia_repo.dart';
import 'package:number_trivia/feature/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/domain/use_cases/get_static_number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  NumberTriviaRepository,
  NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
  NetworkInfo,
  InternetConnectionChecker,
  SharedPreferences,
  http.Client,
  GetStaticNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter
  ])

void main() {
  
}