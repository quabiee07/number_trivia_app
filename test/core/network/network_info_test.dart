import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/network/network_info.dart';

import '../../helper/mock_helper.mocks.dart';


void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockDataConnectionChecker;

  setUp((){
    mockDataConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should foward the call to DataConnectionChecker.hasConnection',
    () async {
      final tHasConnectionFuture = Future.value(true);
      //arrange
      when(mockDataConnectionChecker.hasConnection).thenAnswer((_) => tHasConnectionFuture);
      //act
      final result =  networkInfoImpl.isConnected;
      //assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });
    
  });
  
}