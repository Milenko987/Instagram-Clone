import 'package:flutter/material.dart';
import 'package:instgram_clone/utils/colors.dart';

class FollowButton extends StatelessWidget {
  final Function() function;
  final Color borderColor;
  final Color buttonColor;
  final Color textColor;
  final String text;
  const FollowButton(
      {Key? key,
      required this.borderColor,
      required this.buttonColor,
      required this.function,
      required this.text,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 3),
      child: TextButton(
        onPressed: function,
        child: Container(
          width: 250,
          height: 27,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
            color: buttonColor,
          ),
          child: Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
