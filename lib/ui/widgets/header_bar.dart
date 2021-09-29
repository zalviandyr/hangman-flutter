import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hangman/ui/utils/pallette.dart';

class HeaderBar extends StatelessWidget {
  final String label;

  const HeaderBar({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _backAction() {
      Get.back();
    }

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          height: 35.0,
          decoration: const BoxDecoration(
            color: Pallette.backgroundColor2,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
          ),
        ),
        MaterialButton(
          onPressed: _backAction,
          height: 35.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
            ),
          ),
          minWidth: 0.0,
          child: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
