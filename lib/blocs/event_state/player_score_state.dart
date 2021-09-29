import 'package:equatable/equatable.dart';
import 'package:hangman/models/models.dart';

abstract class PlayerScoreState extends Equatable {
  const PlayerScoreState();
}

class PlayerScoreUninitialized extends PlayerScoreState {
  @override
  List<Object?> get props => [];
}

class PlayerScoreLoading extends PlayerScoreState {
  @override
  List<Object?> get props => [];
}

class PlayerScoreFetchSuccess extends PlayerScoreState {
  final List<User> users;

  const PlayerScoreFetchSuccess({required this.users});

  @override
  List<Object?> get props => [users];
}
