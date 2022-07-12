part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForStaticNumber extends NumberTriviaEvent{
  final String numberString;

  const GetTriviaForStaticNumber({required this.numberString});
}


class GetTriviaForRandomNumber extends NumberTriviaEvent { }