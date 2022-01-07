import 'package:flutter/material.dart';

Widget titleText(String title) {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      Color(0xffDA44bb),
      Color(0xff8921aa),
    ],
  ).createShader(
    Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
  );
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        style: new TextStyle(
            fontSize: 20.0,
            fontFamily: 'Fredoka One',
            foreground: Paint()..shader = linearGradient),
      ),
      Text(
        "Academy",
        style: new TextStyle(
          fontSize: 15.0,
          fontFamily: 'Poppins',
          color: Colors.black87,
        ),
      ),
    ],
  );
}
