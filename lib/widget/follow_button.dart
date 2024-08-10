import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color textColor;
  const FollowButton({super.key, required this.onPressed, required this.backgroundColor, required this.borderColor, required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: TextButton(
        onPressed:onPressed,
        child:Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          width: 200,
          height: 32,
          child: Text(text,style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold
          ),
          ),
        )
      ),
    );
  }
}
