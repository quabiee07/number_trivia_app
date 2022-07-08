import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]] );
}

//some general failure

class ServerFailure extends Failure{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
 
class CacheFailure extends Failure{
  @override
  // TODO: implement props
  List<Object?> get props =>[ ];
}

