import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hangman/blocs/event_state/event_state.dart';

class HangmanBloc extends Bloc<HangmanEvent, HangmanState> {
  int _curState = 0;
  final List<Image> _images = [
    Image.asset('assets/images/0.png'),
    Image.asset('assets/images/1.png'),
    Image.asset('assets/images/2.png'),
    Image.asset('assets/images/3.png'),
    Image.asset('assets/images/4.png'),
    Image.asset('assets/images/5.png'),
    Image.asset('assets/images/6.png'),
  ];
  HangmanBloc()
      : super(HangmanCondition(image: Image.asset('assets/images/0.png'))) {
    for (Image image in _images) {
      // preload image to speed up show image
      precacheImage(image.image, Get.context!);
    }
  }

  @override
  Stream<HangmanState> mapEventToState(HangmanEvent event) async* {
    if (event is HangmanReset) {
      _curState = 0;

      yield HangmanCondition(
          image: _images[_curState], isLose: false, isWin: false);
    }

    if (event is HangmanAddCondition) {
      if (event.setWin) {
        yield HangmanCondition(image: _images[_curState], isWin: true);
      } else {
        if (_curState < 6) {
          _curState += 1;

          if (_curState == 6) {
            yield HangmanCondition(image: _images[_curState], isLose: true);
          } else {
            yield HangmanCondition(image: _images[_curState]);
          }
        }
      }
    }
  }
}
