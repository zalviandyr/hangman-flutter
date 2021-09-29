import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/blocs/blocs.dart';
import 'package:hangman/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreCubit extends Cubit<int> {
  final HighScoreCubit _highScoreCubit;
  ScoreCubit(this._highScoreCubit) : super(0);

  void add(int answerLength) => emit(state + answerLength);

  Future<void> saveScore() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String userId = preferences.getString('user_id')!;
      String userName = preferences.getString('user_name')!;
      int highScore = preferences.getInt('high_score') ?? 0;

      // save only high score
      if (state > highScore) {
        FirebaseDatabase database = FirebaseDatabase.instance;
        DatabaseReference ref = database.reference();
        DataSnapshot snapshot = await ref.once();
        var value = snapshot.value;

        User user = User(
          id: userId,
          name: userName,
          highScore: state,
        );

        if (value == null) {
          ref.push().set(user.toMap());
        } else {
          String? key;
          for (var data in snapshot.value.entries) {
            String fireUserId = data.value['user_id'];
            if (fireUserId == userId) {
              key = data.key;
              break;
            }
          }

          if (key != null) {
            DatabaseReference child = ref.child(key);
            child.update({'high_score': highScore});
          } else {
            ref.push().set(user.toMap());
          }
        }

        // update local
        await preferences.setInt('high_score', state);
        _highScoreCubit.update(state);
      }
    } catch (error) {
      print(error);
    }
  }
}
