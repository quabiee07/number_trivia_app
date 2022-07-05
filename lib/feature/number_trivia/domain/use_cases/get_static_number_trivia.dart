import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/domain/repositories/number_trivia_repo.dart';

class GetStaticNumberTrivia {
  final NumberTriviaRepository repository;
  GetStaticNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> call(Parameters params) async {
    return await repository.getStaticNumberTrivia(params.number);
  }
}
class Parameters extends Equatable {
  final int number;
  const Parameters(this.number);
  
  @override
  List<Object?> get props => [number];
}