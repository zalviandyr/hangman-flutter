import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/blocs/event_state/event_state.dart';
import 'package:hangman/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserUninitialized()) {
    on(_onUserCheckFirstTime);
    on(_onUserReRetrieveData);
    on(_onUserStoreData);
  }

  Future<void> _onUserCheckFirstTime(
      UserCheckFirstTime event, Emitter<UserState> emit) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString('user_id');
    String? userName = preferences.getString('user_name');
    int? highScore = preferences.getInt('high_score');

    if (userId == null && userName == null) {
      emit(UserFirstTime());
    } else {
      User user = User(
        id: userId!,
        name: userName!,
        highScore: highScore ?? 0,
      );

      emit(UserRetrieveData(user: user));
    }
  }

  Future<void> _onUserReRetrieveData(
      UserReRetrieveData event, Emitter<UserState> emit) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString('user_id');
    String? userName = preferences.getString('user_name');
    int? highScore = preferences.getInt('high_score');

    User user = User(
      id: userId!,
      name: userName!,
      highScore: highScore ?? 0,
    );

    emit(UserRetrieveData(user: user));
  }

  Future<void> _onUserStoreData(
      UserStoreData event, Emitter<UserState> emit) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String name = event.name;

    await preferences.setString('user_id', userId);
    await preferences.setString('user_name', name);

    User user = User(id: userId, name: name);
    emit(UserRetrieveData(user: user));
  }
}
