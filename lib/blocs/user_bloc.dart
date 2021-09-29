import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/blocs/event_state/event_state.dart';
import 'package:hangman/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserUninitialized());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    try {
      if (event is UserCheckFirstTime) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? userId = preferences.getString('user_id');
        String? userName = preferences.getString('user_name');
        int? highScore = preferences.getInt('high_score');

        if (userId == null && userName == null) {
          yield UserFirstTime();
        } else {
          User user = User(
            id: userId!,
            name: userName!,
            highScore: highScore ?? 0,
          );

          yield UserRetrieveData(user: user);
        }
      }

      if (event is UserReRetrieveData) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? userId = preferences.getString('user_id');
        String? userName = preferences.getString('user_name');
        int? highScore = preferences.getInt('high_score');

        User user = User(
          id: userId!,
          name: userName!,
          highScore: highScore ?? 0,
        );

        yield UserRetrieveData(user: user);
      }

      if (event is UserStoreData) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String userId =
            DateTime.now().toUtc().millisecondsSinceEpoch.toString();
        String name = event.name;

        await preferences.setString('user_id', userId);
        await preferences.setString('user_name', name);

        User user = User(id: userId, name: name);
        yield UserRetrieveData(user: user);
      }
    } catch (err) {
      print(err);
    }
  }
}
