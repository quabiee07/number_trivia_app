import 'package:mockito/annotations.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/feature/number_trivia/data/data_src/number_trivia_local_data_source.dart';
import 'package:number_trivia/feature/number_trivia/data/data_src/number_trivia_remote_data_source.dart';
import 'package:number_trivia/feature/number_trivia/domain/repositories/number_trivia_repo.dart';

@GenerateMocks([
  NumberTriviaRepository,
  NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
  NetworkInfo
  ])

void main() {
  
}