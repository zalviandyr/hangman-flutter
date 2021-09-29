import 'package:flutter/material.dart';
import 'package:hangman/ui/utils/pallette.dart';
import 'package:hangman/ui/utils/responsive.dart';
import 'package:hangman/ui/widgets/widgets.dart';

class HelpScreen extends StatelessWidget {
  final List<String> _helps = [
    'Tebak jawab dari pertanyaan yang diberikan menggunakan keyboard yang sudah disediakan',
    'Pertanyaan seputar Pengetahuan Umum',
    'Setiap kata yang sudah ditekan tidak bisa ditekan lagi',
    'Jika kata yang ditekan benar maka akan mengisi kekosongan jawaban yang ada',
    'Jika kata yang ditekan salah maka rangkaian Hangman akan tersusun',
    'Jika semakin banyak kata yang salah dan rangkaian Hangman tersusun sempurna, maka Hati akan berkurang',
    'Skor tertinggi disimpan ketika user "Menyerah" atau keluar dengan paksa dari Game',
  ];

  HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EdgeInsets _screenPadding = Responsive.getPlatform() == OS.android ||
            Responsive.getPlatform() == OS.ios
        ? const EdgeInsets.only(
            top: 30.0, bottom: 20.0, left: 10.0, right: 10.0)
        : EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: MediaQuery.of(context).size.width * 0.1);

    return Scaffold(
      body: Padding(
        padding: _screenPadding,
        child: ListView(
          children: [
            const HeaderBar(
              label: 'Panduan Bermain',
            ),
            const SizedBox(height: 10.0),
            ..._buildHelp(),
            const SizedBox(height: 10.0),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              height: 35.0,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Pallette.backgroundColor2,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: const Text('Selamat Bermain'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHelp() {
    return _helps
        .asMap()
        .entries
        .map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text('${e.key + 1}. ${e.value}'),
          ),
        )
        .toList();
  }
}
