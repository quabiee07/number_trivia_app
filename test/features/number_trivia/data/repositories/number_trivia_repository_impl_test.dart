import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/feature/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';

import '../../../../helper/mock_helper.mocks.dart';

void main() {
  late NumberTriviarRepositoryImpl repositoryImpl;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repositoryImpl = NumberTriviarRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  
  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('Should check if device is online', () {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getStaticNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);
      // act
      repositoryImpl.getStaticNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getStaticNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repositoryImpl.getStaticNumberTrivia(tNumber);

        // assert
        verify(mockRemoteDataSource.getStaticNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cached the data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getStaticNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        // act
        await repositoryImpl.getStaticNumberTrivia(tNumber);

        // assert
        verify(mockRemoteDataSource.getStaticNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getStaticNumberTrivia(tNumber))
            .thenThrow(ServerException());

        // act
        final result = await repositoryImpl.getStaticNumberTrivia(tNumber);

        // assert
        verify(mockRemoteDataSource.getStaticNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repositoryImpl.getStaticNumberTrivia(tNumber);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test(
          'should return CachedFailure when there is no cached data is present',
          () async {
        // arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result = await repositoryImpl.getStaticNumberTrivia(tNumber);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });

  
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('Should check if device is online', () {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      // act
      repositoryImpl.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repositoryImpl.getRandomNumberTrivia();

        // assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cached the data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        // act
        await repositoryImpl.getRandomNumberTrivia();

        // assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        // act
        final result = await repositoryImpl.getRandomNumberTrivia();

        // assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repositoryImpl.getRandomNumberTrivia();

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test(
          'should return Cache Failure when there is no cached data is present',
          () async {
        // arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result = await repositoryImpl.getRandomNumberTrivia();

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });

}
