import 'package:flutter_bloc/flutter_bloc.dart';

class HighScoreCubit extends Cubit<int> {
  HighScoreCubit() : super(0);

  void update(int score) => emit(score);
}
