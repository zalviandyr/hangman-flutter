import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/blocs/event_state/event_state.dart';
import 'package:hangman/models/models.dart';

class PlayerScoreBloc extends Bloc<PlayerScoreEvent, PlayerScoreState> {
  PlayerScoreBloc() : super(PlayerScoreUninitialized());

  @override
  Stream<PlayerScoreState> mapEventToState(PlayerScoreEvent event) async* {
    try {
      if (event is PlayerScoreFetch) {
        yield PlayerScoreLoading();

        List<User> users = [];
        FirebaseDatabase database = FirebaseDatabase.instance;
        DatabaseReference ref = database.reference();
        DataSnapshot snapshot = await ref.once();

        for (var data in snapshot.value.entries) {
          users.add(User.fromMap(data.value));
        }

        yield PlayerScoreFetchSuccess(users: users);
      }
    } catch (error) {
      print(error);
    }
  }
}
