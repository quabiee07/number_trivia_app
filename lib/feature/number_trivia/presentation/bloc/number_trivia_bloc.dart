import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/domain/use_cases/get_static_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid input: The number must be a positive integer or failure';

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
        final inputEither = inputConverter.stringToUnsignedString(event.numberString);

        inputEither.fold((failure) => emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE)) , (r) => throw UnimplementedError() );
        
      }
    });
  }
}
