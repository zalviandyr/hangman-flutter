import 'package:flutter/material.dart';
import 'package:hangman/ui/utils/pallette.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color color;
  final Color textColor;

  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.color = Pallette.buttonColor1,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      elevation: 10.0,
      minWidth: 250.0,
      height: 50.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor),
      ),
      onPressed: onPressed,
    );
  }
}
