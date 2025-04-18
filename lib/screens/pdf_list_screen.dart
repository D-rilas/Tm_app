import 'package:flutter/material.dart';
import '../models/pdf_document.dart';
import 'pdf_viewer_screen.dart';

class PdfListScreen extends StatelessWidget {
  final List<PdfDocument> pdfDocuments = [
    PdfDocument(title: "Document 1", filePath: "/path/to/document1.pdf"),
    PdfDocument(title: "Document 2", filePath: "/path/to/document2.pdf"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My PDFs"),
      ),
      body: ListView.builder(
        itemCount: pdfDocuments.length,
        itemBuilder: (context, index) {
          final document = pdfDocuments[index];
          return ListTile(
            title: Text(document.title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfViewerScreen(pdfDocument: document),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
