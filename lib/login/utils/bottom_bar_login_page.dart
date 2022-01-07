import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomBarLoginPage extends StatelessWidget {
  const BottomBarLoginPage({
    Key? key,
  }) : super(key: key);
  void _launchURL({required String url}) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Opacity(
        opacity: 0.8,
        child: Container(
          height: 100.0,
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage("assets/images/secure.png"),
                        height: 30.0,
                      ),
                      SizedBox(width: 5.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Secured By",
                            style: TextStyle(
                              color: Colors.green,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            "PICCOZONE",
                            style: TextStyle(
                              color: Colors.indigo,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () => _launchURL(
                    url: "https://fastguide.in/app-terms-and-condition/",
                  ),
                  child: Text(
                    "Terms And Condition",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "Roboto",
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
