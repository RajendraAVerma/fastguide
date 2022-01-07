import 'package:flutter/material.dart';

Text gradientText({
  required String text,
  required Color color1,
  required Color color2,
  required String fontFamily,
  required double fontSize,
  FontWeight? fontWeight,
  TextDecoration? textDecoration,
  double? letterSpacing,
}) {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      color1,
      color2,
    ],
  ).createShader(
    Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
  );
  return Text(
    text,
    style: new TextStyle(
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      foreground: Paint()..shader = linearGradient,
      height: 1.1,
      decoration: textDecoration,
    ),
  );
}
