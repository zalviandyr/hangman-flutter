import 'package:equatable/equatable.dart';

abstract class HangmanEvent extends Equatable {
  const HangmanEvent();
}

class HangmanAddCondition extends HangmanEvent {
  final bool setWin;

  const HangmanAddCondition({this.setWin = false});

  @override
  List<Object?> get props => [setWin];
}

class HangmanReset extends HangmanEvent {
  @override
  List<Object?> get props => [];
}
