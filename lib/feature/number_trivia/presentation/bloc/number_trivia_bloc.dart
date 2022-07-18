import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/use_cases/use_case.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/domain/use_cases/get_static_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid input: The number must be a positive integer or failure';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetStaticNumberTrivia getStaticNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc(
      {required this.getStaticNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForStaticNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);
        await inputEither.fold(
            (failure) async =>
                emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE)),
            (integer) async {
          emit(Loading());
          final failureOrTrivia =
              await getStaticNumberTrivia(Parameters(integer));
          _eitherLoadedOrFailureState(emit, failureOrTrivia);
        });
      } else if(event is GetTriviaForRandomNumber){
        emit(Loading());
          final failureOrTrivia =
              await getRandomNumberTrivia(NoParams());
           _eitherLoadedOrFailureState(emit, failureOrTrivia);
      }
    });
  }

  void _eitherLoadedOrFailureState(Emitter<NumberTriviaState> emit, Either<Failure, NumberTrivia> failureOrTrivia) {
    emit(failureOrTrivia.fold(
        (failure) => Error(
            message: _mapFailureToMessage(failure)),
        (trivia) => Loaded(trivia: trivia)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
