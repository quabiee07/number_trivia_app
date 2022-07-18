import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/injection_container.dart';

import '../widget/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Number Trivia')),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (_) => sl<NumberTriviaBloc>(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  //top half
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Center(
                      child: SingleChildScrollView(
                        child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                          builder: (context, state) {
                            if (state is Empty) {
                              return const MessageDisplay(
                                message: 'Start Searching',
                              );
                            } else if (state is Loading) {
                              return const LoadingWidget();
                            } else if (state is Loaded) {
                              return TriviaDisplay(numberTrivia: state.trivia);
                            } else if (state is Error) {
                              return MessageDisplay(
                                message: state.message,
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ),
      
                  const SizedBox(
                    height: 20,
                  ),
  
                  //bottom half
                  const TriviaControl()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TriviaControl extends StatefulWidget {
  const TriviaControl({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControl> createState() => _TriviaControlState();
}

class _TriviaControlState extends State<TriviaControl> {
  final textController = TextEditingController();
  String inputStr = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a Number',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) => dispatchStatic(),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchStatic,
                child: Text('Search'),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: ElevatedButton(
                onPressed: dispatchRandom,
                child: Text('Get random trivia'),
              ),),
          ],
        )
      ],
    );
  }

  void dispatchStatic(){
    textController.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
      .add(GetTriviaForStaticNumber(numberString: inputStr));
  }

  void dispatchRandom(){
    textController.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
      .add(GetTriviaForRandomNumber());
  }
}
