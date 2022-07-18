import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/use_cases/use_case.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/domain/use_cases/get_static_number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import '../../../../helper/mock_helper.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
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

  group('GetTriviaForStaticNumber', () {
    const tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedString(any))
          .thenReturn(Right(tNumberParsed));
    }

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      setUpMockInputConverterSuccess();
    });

    test('should emit [Error] when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedString(any))
          .thenReturn(Left(InvalidInputFailure()));

      bloc.add(const GetTriviaForStaticNumber(numberString: tNumberString));

      final matchers = [
        // Empty(),
        const Error(message: INVALID_INPUT_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream, emitsInOrder(matchers));
    });

    test(
      "should get data from the static  use case",
      () async {
        setUpMockInputConverterSuccess();

        when(mockGetStaticNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        bloc.add(const GetTriviaForStaticNumber(numberString: tNumberString));
        await untilCalled(mockGetStaticNumberTrivia(any));

        verify(mockGetStaticNumberTrivia(Parameters(tNumberParsed)));
      },
    );

    test("should emit [Loading, Loaded] when data is gotten successfully",
        () async {
          //arrange
      setUpMockInputConverterSuccess();
      when(mockGetStaticNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expected = [
        // Empty(), 
        Loading(), 
        Loaded(trivia: tNumberTrivia)];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const GetTriviaForStaticNumber(numberString: tNumberString));
    });

    test("should emit [Loading, Empty] when getting data fails",
        () async {
          //arrange
      setUpMockInputConverterSuccess();
      when(mockGetStaticNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        // Empty(), 
        Loading(), 
        const Error(message: SERVER_FAILURE_MESSAGE)
        ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const GetTriviaForStaticNumber(numberString: tNumberString));
    });

    test("should emit [Loading, Empty] with a proper message from the error when data fails",
        () async {
          //arrange
      setUpMockInputConverterSuccess();
      when(mockGetStaticNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        // Empty(), 
        Loading(), 
        const Error(message: CACHE_FAILURE_MESSAGE)
        ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const GetTriviaForStaticNumber(numberString: tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = 
        NumberTrivia(text: 'test trivia', number: 1);

    test(
      "should get data from the static  use case",
      () async {

        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));

        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test("should emit [Loading, Loaded] when data is gotten successfully",
        ()  {
          //arrange
      
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expected = [
        // Empty(), 
        Loading(), 
        Loaded(trivia: tNumberTrivia)];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(GetTriviaForRandomNumber());
        });
        

    test("should emit [Loading, Empty] when getting data fails",
        () async {
          //arrange
      
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        // Empty(), 
        Loading(), 
        const Error(message: SERVER_FAILURE_MESSAGE)
        ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add( GetTriviaForRandomNumber());
    });

    test("should emit [Loading, Error] with a proper message from the error when data fails",
        () async {
          //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        // Empty(), 
        Loading(), 
        const Error(message: CACHE_FAILURE_MESSAGE)
        ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(GetTriviaForRandomNumber());
    });
  });
 
}
