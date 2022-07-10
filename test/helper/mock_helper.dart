import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/feature/number_trivia/data/data_src/number_trivia_local_data_source.dart';
import 'package:number_trivia/feature/number_trivia/data/data_src/number_trivia_remote_data_source.dart';
import 'package:number_trivia/feature/number_trivia/domain/repositories/number_trivia_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([
  NumberTriviaRepository,
  NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
  NetworkInfo,
  InternetConnectionChecker,
  SharedPreferences
  ])

void main() {
  
}