import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPageViewiFrame extends StatefulWidget {
  const WebPageViewiFrame({
    Key? key,
    required this.title,
    required this.url,
    required this.color,
  }) : super(key: key);
  final String title;
  final String url;
  final Color color;

  @override
  _WebPageViewiFrameState createState() => _WebPageViewiFrameState();
}

class _WebPageViewiFrameState extends State<WebPageViewiFrame> {
  bool isLoading = true;
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: widget.color,
          title:
              Text(widget.title, style: TextStyle(fontWeight: FontWeight.w700)),
          centerTitle: true),
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ],
      ),
    );
  }
}
