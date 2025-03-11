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
        DatabaseReference ref = database.ref();
        DatabaseEvent event = await ref.once();

        if (event.snapshot.value != null && event.snapshot.value is Map) {
          Map dataMap = event.snapshot.value as Map;

          users = dataMap.entries
              .map((entry) => User.fromMap(entry.value as Map<String, dynamic>))
              .toList();
        }

        users.sort((a, b) => b.highScore.compareTo(a.highScore));

        yield PlayerScoreFetchSuccess(users: users);
      }
    } catch (error) {
      print(error);
    }
  }
}
