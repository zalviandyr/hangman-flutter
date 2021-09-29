import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hangman/blocs/blocs.dart';
import 'package:hangman/blocs/event_state/event_state.dart';
import 'package:hangman/models/models.dart';
import 'package:hangman/ui/screens/screens.dart';
import 'package:hangman/ui/utils/pallette.dart';
import 'package:hangman/ui/utils/responsive.dart';
import 'package:hangman/ui/widgets/widgets.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late ListQuestionCubit _listQuestionCubit;
  late HangmanBloc _hangmanBloc;
  late LifeCubit _lifeCubit;
  late ScoreCubit _scoreCubit;
  final List<List<Keyboard>> _alphabets = Keyboard.alphabets();
  final List<String> _hiddenAnswers = [];
  final List<String> _answers = [];
  final EdgeInsets _screenPadding = Responsive.getPlatform() == OS.android ||
          Responsive.getPlatform() == OS.ios
      ? const EdgeInsets.only(top: 30.0, bottom: 20.0, left: 10.0, right: 10.0)
      : const EdgeInsets.all(10.0);

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);

    _listQuestionCubit = BlocProvider.of<ListQuestionCubit>(context);
    _hangmanBloc = BlocProvider.of<HangmanBloc>(context);
    _lifeCubit = BlocProvider.of<LifeCubit>(context);
    _scoreCubit = BlocProvider.of<ScoreCubit>(context);

    super.initState();
  }

  @override
  void deactivate() {
    // when user push back button or Navigator.pop();
    // reset
    _clearAnswer();
    _nextQuestion();

    _scoreCubit.saveScore();

    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if user click home button
    if (state == AppLifecycleState.inactive) {
      _scoreCubit.saveScore();
    }

    super.didChangeAppLifecycleState(state);
  }

  void _hangmanListener(BuildContext context, HangmanState state) {
    if (state is HangmanCondition && state.isLose) {
      if (_lifeCubit.state == 0) {
        _showGameOverDialog();
      } else {
        _lifeCubit.decrease();
        _hangmanBloc.add(HangmanReset());

        _showLoseDialog();
      }
    }

    if (state is HangmanCondition && state.isWin) {
      _scoreCubit.add(_answers.length);
      _nextQuestion();
      _showNextQuestionSnackbar();
    }
  }

  void _clearAnswer() {
    Question question = _listQuestionCubit.currentQuestion;

    if (question.answer != _answers.join('')) {
      // set real answer
      _answers.clear();
      _answers.addAll(question.answer.split(''));

      // set hidden answer
      _hiddenAnswers.clear();
      _hiddenAnswers.addAll(List.generate(_answers.length, (_) => ' '));
    }
  }

  void _nextQuestion() {
    _listQuestionCubit.removeFirstQuestion();

    // reset keyboard
    for (List<Keyboard> element in _alphabets) {
      for (Keyboard keyboard in element) {
        keyboard.isSelected = false;
      }
    }
  }

  void _showLoseDialog() {
    Question question = _listQuestionCubit.currentQuestion;

    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: false,
      barrierLabel: 'LoseDialog',
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: WillPopScope(
            onWillPop: () async {
              Get.back();

              _nextQuestion();
              return false;
            },
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/sad_face.png',
                      width: 150.0,
                    ),
                    const SizedBox(height: 30.0),
                    Text(
                      question.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      question.answer,
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 30.0),
                    PrimaryButton(
                      label: 'Lanjut',
                      color: const Color(0xFF0078FF),
                      textColor: Colors.white,
                      onPressed: () {
                        Get.back();

                        _nextQuestion();
                      },
                    ),
                    const SizedBox(height: 10.0),
                    PrimaryButton(
                      label: 'Nyerah',
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {
                        Get.offAll(() => const HomeScreen());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      pageBuilder: (context, a1, a2) {
        return const SizedBox.shrink();
      },
    );
  }

  void _showGameOverDialog() {
    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Game Over',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Pallette.red),
                  ),
                  const SizedBox(height: 20.0),
                  PrimaryButton(
                    onPressed: () => Get.offAll(() => const HomeScreen()),
                    label: 'Ok',
                  ),
                ],
              ),
            ),
          ),
        );
      },
      pageBuilder: (context, a1, a2) {
        return const SizedBox.shrink();
      },
    );
  }

  Future<bool> _showConfirmExitDialog() async {
    return (await showGeneralDialog<bool>(
          context: context,
          transitionDuration: const Duration(milliseconds: 200),
          barrierDismissible: false,
          barrierLabel: 'LoseDialog',
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Yakin ingin keluar ?',
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 30.0),
                      PrimaryButton(
                        label: 'Tidak',
                        color: const Color(0xFF0078FF),
                        textColor: Colors.white,
                        onPressed: () {
                          Get.back(result: false);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      PrimaryButton(
                        label: 'Keluar',
                        color: Colors.red,
                        textColor: Colors.white,
                        onPressed: () {
                          Get.back(result: true);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          pageBuilder: (context, a1, a2) {
            return const SizedBox.shrink();
          },
        )) ??
        false;
  }

  void _showNextQuestionSnackbar() {
    Get.rawSnackbar(
      message: 'Yeay, lanjut ke pertanyaan selanjutnya',
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.TOP,
      borderRadius: 20.0,
      margin: const EdgeInsets.all(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HangmanBloc, HangmanState>(
      listener: _hangmanListener,
      child: WillPopScope(
        onWillPop: _showConfirmExitDialog,
        child: Scaffold(
          body: BlocBuilder<ListQuestionCubit, List<Question>>(
            builder: (context, state) {
              if (state.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              Question question = state[0];
              _clearAnswer();

              return Padding(
                padding: _screenPadding,
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20.0),
                    Container(
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                      ),
                      child: Text(
                        question.question,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    BlocBuilder<HangmanBloc, HangmanState>(
                      builder: (context, state) {
                        if (state is HangmanCondition) {
                          return SizedBox(
                            width: 250.0,
                            height: 300.0,
                            child: state.image,
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _hiddenAnswers
                          .asMap()
                          .entries
                          .map(
                            (e) => Flexible(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Column(
                                  children: [
                                    Text(e.value),
                                    Text((_answers[e.key] == ' ') ? ' ' : '_'),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const Spacer(),
                    _buildKeyboard(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BlocBuilder<LifeCubit, int>(
          builder: (context, state) {
            return Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.favorite,
                  color: Pallette.red,
                  size: 40.0,
                ),
                Positioned(
                  bottom: 9.0,
                  child: Text(state.toString()),
                ),
              ],
            );
          },
        ),
        BlocBuilder<ScoreCubit, int>(
          builder: (context, state) {
            return Text(
              state.toString(),
              style: Theme.of(context).textTheme.bodyText1,
            );
          },
        ),
      ],
    );
  }

  Widget _buildKeyboard() {
    return Column(
      children: _alphabets
          .map(
            (e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: e
                  .map(
                    (keyboard) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: KeyboardButton(
                        isSelected: keyboard.isSelected,
                        label: keyboard.alphabet,
                        onPressed: keyboard.isSelected
                            ? () {}
                            : () {
                                String alphabet =
                                    keyboard.alphabet.toUpperCase();

                                bool isExist = false;
                                for (int i = 0; i < _answers.length; i++) {
                                  if (_answers[i].toUpperCase() == alphabet) {
                                    _hiddenAnswers[i] = alphabet;
                                    isExist = true;
                                  }
                                }

                                // update hangman condition if user wrong
                                if (!isExist) {
                                  _hangmanBloc.add(const HangmanAddCondition());
                                }

                                // update if user correct
                                if (_answers.join('').toLowerCase() ==
                                    _hiddenAnswers.join('').toLowerCase()) {
                                  _hangmanBloc.add(
                                      const HangmanAddCondition(setWin: true));
                                }

                                setState(() => keyboard.isSelected = true);
                              },
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}
