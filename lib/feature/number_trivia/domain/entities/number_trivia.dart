import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final String text;
  final int number;

  const NumberTrivia({
    required this.text, 
    required this.number,
    });
    
      @override
      // TODO: implement props
      List<Object?> get props => [text, number];
}
