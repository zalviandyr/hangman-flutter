import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HangmanState extends Equatable {
  const HangmanState();
}

class HangmanCondition extends HangmanState {
  final Image image;
  final bool isLose;
  final bool isWin;

  const HangmanCondition({
    required this.image,
    this.isLose = false,
    this.isWin = false,
  });

  @override
  List<Object?> get props => [image, isLose, isWin];
}
