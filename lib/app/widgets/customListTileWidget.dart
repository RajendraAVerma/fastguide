import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class customListTileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Share.share(
          'Download FastGuide App :-  https://fastguide.in/download-app',
          subject: 'FastGuide - Self Directed Learning App !'),
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Image(image: AssetImage("assets/images/share.png")),
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                flex: 5,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gradientText(
                        text: "Share With Friends",
                        color1: Colors.blue,
                        color2: Colors.blueAccent,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      gradientText(
                        text:
                            "Help Your Friend Fall in love with learning through FastGuide",
                        color1: Colors.grey,
                        color2: Colors.grey,
                        fontFamily: 'Roboto',
                        fontSize: 9.0,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                flex: 1,
                child: Container(
                  child: Image(image: AssetImage("assets/images/gift.png")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
