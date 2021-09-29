import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hangman/blocs/blocs.dart';
import 'package:hangman/blocs/event_state/event_state.dart';
import 'package:hangman/ui/screens/screens.dart';
import 'package:hangman/ui/utils/responsive.dart';
import 'package:hangman/ui/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HighScoreCubit _highScoreCubit;
  late UserBloc _userBloc;
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final EdgeInsets _screenPadding = Responsive.getPlatform() == OS.android ||
          Responsive.getPlatform() == OS.ios
      ? const EdgeInsets.only(top: 50.0, bottom: 20.0, left: 10.0, right: 10.0)
      : const EdgeInsets.all(30.0);

  @override
  void initState() {
    _highScoreCubit = BlocProvider.of<HighScoreCubit>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);

    // check user
    _userBloc.add(UserCheckFirstTime());

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  void _toGameAction() {
    Get.to(
      () => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ListQuestionCubit()),
          BlocProvider(create: (_) => HangmanBloc()),
          BlocProvider(create: (_) => LifeCubit()),
          BlocProvider(create: (_) => ScoreCubit(_highScoreCubit)),
        ],
        child: const GameScreen(),
      ),
    );
  }

  void _toPlayerScoreAction() {
    Get.to(
      () => BlocProvider(
        create: (_) => PlayerScoreBloc(),
        child: const PlayerScoreScreen(),
      ),
    );
  }

  void _toHelpAction() {
    Get.to(() => HelpScreen());
  }

  String? _inputNameValidator(String? value) {
    if (value != null && value != '') {
      return null;
    }

    return 'Tidak boleh kosong';
  }

  void _inputNameAction() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;

      _userBloc.add(UserStoreData(name: name));

      Get.back();
    }
  }

  void _userListener(BuildContext context, UserState state) {
    if (state is UserFirstTime) {
      showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 200),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 20.0,
                  ),
                  width: 200.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _nameController,
                          validator: _inputNameValidator,
                          decoration: const InputDecoration(
                            hintText: 'Masukkan nama',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      PrimaryButton(
                        onPressed: _inputNameAction,
                        label: 'Ok',
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
    } else if (state is UserRetrieveData) {
      _highScoreCubit.update(state.user.highScore);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: _userListener,
      child: Scaffold(
        body: Padding(
          padding: _screenPadding,
          child: Column(
            children: [
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  String name = '';

                  if (state is UserRetrieveData) {
                    name = state.user.name;
                  }

                  return InfoBar(
                    label: 'Hai, $name',
                  );
                },
              ),
              const SizedBox(height: 40.0),
              Text(
                'Hangman',
                style: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox(height: 30.0),
              PrimaryButton(
                label: 'Mulai main',
                onPressed: _toGameAction,
              ),
              const SizedBox(height: 10.0),
              PrimaryButton(
                label: 'Skor pemain',
                onPressed: _toPlayerScoreAction,
              ),
              const SizedBox(height: 10.0),
              PrimaryButton(
                label: 'Panduan bermain',
                onPressed: _toHelpAction,
              ),
              const SizedBox(height: 70.0),
              Text(
                'Skor tertinggi mu',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 20.0),
              BlocBuilder<HighScoreCubit, int>(
                builder: (context, state) {
                  return Text(
                    state.toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
