import 'package:flutter/material.dart';
import 'package:hangman/ui/utils/pallette.dart';
import 'package:hangman/ui/utils/responsive.dart';

class KeyboardButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  const KeyboardButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isWeb = Responsive.getPlatform() == OS.web;
    double width = isWeb ? MediaQuery.of(context).size.width * 0.1 : 51.0;

    return MaterialButton(
      onPressed: onPressed,
      minWidth: width,
      height: 50.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: isSelected ? Pallette.buttonColor2 : Pallette.buttonColor1,
      child: Text(label),
    );
  }
}
