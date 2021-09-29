import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hangman/blocs/blocs.dart';
import 'package:hangman/ui/screens/screens.dart';
import 'package:hangman/ui/utils/pallette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HighScoreCubit()),
        BlocProvider(create: (_) => UserBloc()),
      ],
      child: GetMaterialApp(
        title: 'Hangman',
        theme: ThemeData(
          scaffoldBackgroundColor: Pallette.backgroundColor,
          colorScheme: const ColorScheme.light(
            secondary: Pallette.backgroundColor2,
          ),
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontFamily: 'Gluten',
              fontSize: 40.0,
              color: Colors.white,
            ),
            bodyText1: TextStyle(
              fontFamily: 'Gluten',
              fontSize: 30.0,
              color: Colors.white,
            ),
            bodyText2: TextStyle(
              fontFamily: 'Gluten',
              fontSize: 20.0,
              color: Colors.white,
            ),
            subtitle1: TextStyle(
              fontFamily: 'Gluten',
              fontSize: 20.0,
              color: Colors.black,
            ),
            caption: TextStyle(
              fontFamily: 'Gluten',
              fontSize: 15.0,
              color: Colors.red,
            ),
            button: TextStyle(
              fontFamily: 'Gluten',
              fontSize: 25.0,
            ),
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
