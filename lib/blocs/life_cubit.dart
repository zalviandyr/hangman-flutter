import 'package:flutter_bloc/flutter_bloc.dart';

class LifeCubit extends Cubit<int> {
  LifeCubit() : super(5);

  void decrease() => emit(state - 1);
}
