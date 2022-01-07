import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFviewer extends StatelessWidget {
  PDFviewer({
    Key? key,
    required this.link,
    required this.title,
    required this.color,
  }) : super(key: key);
  final String link;
  final String title;
  final int color;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(color),
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: Container(
        child: SfPdfViewer.network(
          link,
          key: _pdfViewerKey,
          // onDocumentLoadFailed: (details) => Column(
          //   children: [
          //     Text(
          //       details.error,
          //       style: TextStyle(
          //         color: Colors.red,
          //         fontSize: 50.0,
          //       ),
          //     ),
          //     Text(details.description),
          //   ],
          // ),
        ),
      ),
    );
  }
}
