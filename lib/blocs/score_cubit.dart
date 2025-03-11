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
        DatabaseReference ref = database.ref();
        DataSnapshot snapshot = await ref.get();

        User user = User(
          id: userId,
          name: userName,
          highScore: state,
        );

        if (!snapshot.exists) {
          // Jika database kosong, tambahkan user baru
          await ref.push().set(user.toMap());
        } else {
          String? key;
          Map<Object?, Object?> dataMap =
              snapshot.value as Map<Object?, Object?>;

          // Mencari user dengan user_id yang sama
          key = dataMap.entries
              .firstWhere(
                (entry) =>
                    entry.value is Map &&
                    (entry.value as Map)['user_id'] == userId,
                orElse: () => const MapEntry(null, null),
              )
              .key as String?;

          if (key != null) {
            // Update skor jika user ditemukan
            await ref.child(key).update({'high_score': state});
          } else {
            // Tambahkan user baru jika tidak ditemukan
            await ref.push().set(user.toMap());
          }
        }

        // Update high score secara lokal
        await preferences.setInt('high_score', state);
        _highScoreCubit.update(state);
      }
    } catch (error) {
      print(error);
    }
  }
}
