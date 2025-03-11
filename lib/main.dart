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
            displayLarge: TextStyle(
              fontFamily: 'Gluten',
              fontSize: 40.0,
              color: Colors.white,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'Gluten',
              fontSize: 30.0,
              color: Colors.white,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Gluten',
              fontSize: 20.0,
              color: Colors.white,
            ),
            titleMedium: TextStyle(
              fontFamily: 'Gluten',
              fontSize: 20.0,
              color: Colors.black,
            ),
            bodySmall: TextStyle(
              fontFamily: 'Gluten',
              fontSize: 15.0,
              color: Colors.red,
            ),
            labelLarge: TextStyle(
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
