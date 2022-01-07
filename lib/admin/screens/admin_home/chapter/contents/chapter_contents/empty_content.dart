import 'package:fastguide/app/widgets/all_type_text_widget.dart/animated_text.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key? key,
    this.title = 'Nothing here - content',
    this.message = 'Nothing Is Available Right Now',
  }) : super(key: key);
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              child:
                  Image(image: AssetImage('assets/images/learning_bro.png'))),
          Text(
            message,
            style: TextStyle(fontSize: 16.0, color: Colors.black54),
          ),
          animatedHeaderText_1("Coming Soon", 27),
          gradientText(
            text: " जल्द आ रहा है ",
            color1: Colors.blue.shade800,
            color2: Colors.blue.shade700,
            fontFamily: 'Mukta',
            fontSize: 20,
          ),
        ],
      ),
    );
  }
}
