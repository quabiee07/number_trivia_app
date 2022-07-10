import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/feature/number_trivia/data/data_src/number_trivia_local_data_source.dart';
import 'package:number_trivia/feature/number_trivia/data/data_src/number_trivia_remote_data_source.dart';
import 'package:number_trivia/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia/feature/number_trivia/domain/repositories/number_trivia_repo.dart';

import '../../../../core/network/network_info.dart';

typedef _StaticOrRandomChooser =  Future<NumberTriviaModel> Function();

class NumberTriviarRepositoryImpl extends NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviarRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getStaticNumberTrivia(
      int number) async {
    return await _getTrivia(() => remoteDataSource.getStaticNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

   Future<Either<Failure, NumberTrivia>> _getTrivia(
    _StaticOrRandomChooser getStaticOrRandom
   )async {
   
    if (await networkInfo.isConnected) {
      try {
        final remoteTrvia = await getStaticOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrvia);
        return Right(remoteTrvia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
      return Right(localTrivia);
      } on CacheException{
        return Left(CacheFailure());
        
      }
      
    }
   }
}
