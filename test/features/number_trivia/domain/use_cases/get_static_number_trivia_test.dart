import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/feature/number_trivia/domain/use_cases/get_static_number_trivia.dart';

import '../../../../helper/mock_helper.mocks.dart';

void  main() {
  late GetStaticNumberTrivia useCase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetStaticNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia for the number from the repository',() async{
      //arrange
      when(mockNumberTriviaRepository.getStaticNumberTrivia(1))
        .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      final result = await useCase(const Parameters(tNumber));

      //assert
      expect(result,  const Right(tNumberTrivia));

      verify(mockNumberTriviaRepository.getStaticNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);


    },
  );
}
