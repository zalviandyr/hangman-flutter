import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hangman/ui/screens/home_screen.dart';
import 'package:hangman/ui/utils/responsive.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final Future<FirebaseApp> _firebaseInitialize = Future.delayed(
      const Duration(seconds: 5), () => Firebase.initializeApp());

  final Future<void> _initialized = Future.delayed(const Duration(seconds: 5));
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Responsive.getPlatform() == OS.android ||
              Responsive.getPlatform() == OS.ios
          ? _firebaseInitialize
          : _initialized,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const HomeScreen();
        }

        return Scaffold(
          body: Center(
            child: Text(
              'Hangman',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        );
      },
    );
  }
}
