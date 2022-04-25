import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset(
      "assets/images/chatAppTitleCrop.png",
      height: 55,
    ),
    //Text("Chat app"),
  );
}

InputDecoration whiteDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white54,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ));
}

TextStyle whiteText(double fontSize) {
  return TextStyle(
    color: Colors.white,
    fontSize: fontSize,
  );
}
