import 'package:flutter/material.dart';
import 'package:hangman/ui/utils/pallette.dart';

class InfoBar extends StatelessWidget {
  final String label;

  const InfoBar({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Pallette.backgroundColor2,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: const [
          BoxShadow(
            color: Pallette.shadowColor,
            blurRadius: 2.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Text(label),
    );
  }
}
