import 'package:hangman/ui/utils/responsive.dart';

class Keyboard {
  final String alphabet;
  bool isSelected;

  Keyboard({
    required this.alphabet,
    required this.isSelected,
  });

  static List<List<Keyboard>> alphabets() {
    bool isWeb = Responsive.getPlatform() == OS.web;
    if (isWeb) {
      return [
        ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'],
        ['J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R'],
        ['S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'],
      ]
          .map((e) => e
              .map(
                (word) => Keyboard(alphabet: word, isSelected: false),
              )
              .toList())
          .toList();
    }

    return [
      ['A', 'B', 'C', 'D', 'E', 'F', 'G'],
      ['H', 'I', 'J', 'K', 'L', 'M', 'N'],
      ['O', 'P', 'Q', 'R', 'S', 'T', 'U'],
      ['V', 'W', 'X', 'Y', 'Z'],
    ]
        .map((e) => e
            .map(
              (word) => Keyboard(alphabet: word, isSelected: false),
            )
            .toList())
        .toList();
  }
}
