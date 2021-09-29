import 'package:equatable/equatable.dart';

abstract class PlayerScoreEvent extends Equatable {
  const PlayerScoreEvent();
}

class PlayerScoreFetch extends PlayerScoreEvent {
  @override
  List<Object?> get props => [];
}
