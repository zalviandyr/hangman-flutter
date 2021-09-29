import 'package:flutter/material.dart';
import 'package:hangman/models/models.dart';
import 'package:hangman/ui/utils/pallette.dart';

class InfoScoreBar extends StatelessWidget {
  final String rank;
  final User user;

  const InfoScoreBar({
    Key? key,
    required this.rank,
    required this.user,
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
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(rank),
          ),
          Expanded(
            flex: 7,
            child: Text(
              user.name,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              user.highScore.toString(),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
