import 'package:flutter/material.dart';
import '../models/pdf_document.dart';

class PdfViewerScreen extends StatelessWidget {
  final PdfDocument document;

  const PdfViewerScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(document.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Title: ${document.title}'), Text('File Path: ${document.filePath}')],
        ),
      ),
    );
  }
}
