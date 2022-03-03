import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback onClicked;

  const ButtonWidget(
      {Key? key,
      required this.text,
      required this.onClicked,
      this.color,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: backgroundColor ?? Colors.white,
          padding: EdgeInsets.symmetric(
              horizontal: size.width * .05, vertical: size.height * .02)),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: color ?? Colors.black),
      ),
      onPressed: onClicked,
    );
  }
}
