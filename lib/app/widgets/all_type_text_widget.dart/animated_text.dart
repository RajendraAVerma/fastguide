import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

animatedHeaderText_1(String text, double size) {
  const colorizeColors = [
    Colors.red,
    Colors.yellow,
    Colors.pink,
    Colors.blue,
  ];

  return AnimatedTextKit(
    animatedTexts: [
      ColorizeAnimatedText(
        text,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: size,
          fontFamily: 'Mukta',
        ),
        colors: colorizeColors,
      ),
    ],
    isRepeatingAnimation: true,
    onTap: () {
      print("Tap Event");
    },
  );
}

animatedHeaderText_2(String text) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      // const Text(
      //   'Be',
      //   style: TextStyle(fontSize: 43.0),
      // ),
      DefaultTextStyle(
        style: const TextStyle(
          fontSize: 25.0,
          fontFamily: 'Horizon',
        ),
        child: AnimatedTextKit(animatedTexts: [
          RotateAnimatedText(
            text,
            textStyle: TextStyle(
              color: Colors.blue,
            ),
          ),
          //RotateAnimatedText('OPTIMISTIC'),
          RotateAnimatedText(
            'Learning App',
            textStyle: TextStyle(
              color: Colors.blue,
            ),
          ),
        ]
            // onTap: () {
            //   print("Tap Event");
            // },
            ),
      ),
    ],
  );
}
