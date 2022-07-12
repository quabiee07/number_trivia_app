import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late NumberTriviaBloc bloc;
  late MockGetStaticNumberTrivia mockGetStaticNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetStaticNumberTrivia = MockGetStaticNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getStaticNumberTrivia: mockGetStaticNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initial state should be empty', () {
    //arrange
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForStatiNumber', () {
    const tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      when(mockInputConverter.stringToUnsignedString(any))
          .thenReturn(Right(tNumberParsed));
    });

    test('should emit [Error] when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedString(any))
          .thenReturn(Left(InvalidInputFailure()));

      bloc.add(const GetTriviaForStaticNumber(numberString: tNumberString));

      final matchers = [Empty(),const Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(bloc.stream,
          emitsInOrder(matchers));
    });
  });
}
