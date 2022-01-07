import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CachePDFviewer extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<CachePDFviewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  File? _tempFile;

  @override
  void initState() {
    initializeFile();
    super.initState();
  }

  void initializeFile() async {
    final Directory tempPath = await getApplicationDocumentsDirectory();
    final File tempFile = File(tempPath.path + '/flutter_succinctly.pdf');
    final bool checkFileExist = await tempFile.exists();
    if (checkFileExist) {
      _tempFile = tempFile;
    }
    print("Initial Done >>>>>>>>>>");
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_tempFile == null) {
      child = SfPdfViewer.network(
          'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
          key: _pdfViewerKey,
          onDocumentLoaded: (PdfDocumentLoadedDetails details) async {
        final Directory tempPath = await getApplicationDocumentsDirectory();
        _tempFile = await File(tempPath.path + '/flutter_succinctly.pdf')
            .writeAsBytes(details.document.save());
      });
    } else {
      child = SfPdfViewer.file(
        _tempFile!,
        key: _pdfViewerKey,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter PDF Viewer'),
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
      body: child,
    );
  }
}
