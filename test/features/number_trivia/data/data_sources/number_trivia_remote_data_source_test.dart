import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/feature/number_trivia/data/data_src/number_trivia_remote_data_source.dart';
import 'package:number_trivia/feature/number_trivia/data/models/number_trivia_model.dart';
import '../../../../fixtures/fixture_reader.dart';
import '../../../../helper/mock_helper.mocks.dart';
import 'package:http/http.dart' as http;

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure400() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('something when wrong', 404));
  }

  group('getConcreteNumberTrvia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perfeorm a Get request on a URL with number
     being the endpoint and with application/json header''', () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      dataSource.getStaticNumberTrivia(tNumber);
      // assert

      verify(mockHttpClient
          .get(Uri.parse('http://numbersapi.com/$tNumber'), headers: {'Content-Type': 'application/json'}));
    });

    test('should return number trivia when the status code is 200 (Success)',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource.getStaticNumberTrivia(tNumber);
      // assert

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a server exception when the response code is not 200',
        () async {
      // arrange
      setUpMockHttpClientFailure400();
      // act
      final call = dataSource.getStaticNumberTrivia;
      // assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on a URL with number
       being the endpoint and application/json header''', () {
      setUpMockHttpClientSuccess200();

      dataSource.getRandomNumberTrivia();

      verify(mockHttpClient
          .get(Uri.parse('http://numbersapi.com/random'), headers: {"Content-Type": "application/json"}));
    });
    test('should return numberTrivia when response code is 200(success)', () async{
      setUpMockHttpClientSuccess200();
      final result = await dataSource.getRandomNumberTrivia();

      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () {
      setUpMockHttpClientFailure400();
      final call = dataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
