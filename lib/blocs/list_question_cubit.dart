import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/models/models.dart';

class ListQuestionCubit extends Cubit<List<Question>> {
  final Future<List<Question>> _listQuestion = Question.getQuestions();

  ListQuestionCubit() : super([]) {
    _listQuestion.then((value) => emit(value));
  }

  void removeFirstQuestion() {
    state.removeAt(0);
    List<Question> _renew = [];
    _renew.addAll(state);

    emit(_renew);
  }

  Question get currentQuestion {
    return state[0];
  }
}
