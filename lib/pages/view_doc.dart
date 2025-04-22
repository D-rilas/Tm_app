import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tm_app/models/document.dart';
import 'dart:core';

class ViewDocumentPage extends StatefulWidget {
  final technicals_manuals document;

  const ViewDocumentPage({super.key, required this.document});

  @override
  State<ViewDocumentPage> createState() => _ViewDocumentPageState();
}

class _ViewDocumentPageState extends State<ViewDocumentPage> {
  bool _hasError = false;
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Implémenter le téléchargement
            },
          ),
        ],
      ),
      body: _hasError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error loading PDF',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : SfPdfViewer.network(
              Uri.encodeFull(widget.document.file_url),
              controller: _pdfViewerController,
              enableDoubleTapZooming: true,
              enableTextSelection: true,
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                setState(() {
                  _hasError = true;
                });
              },
            ),
    );
  }
}
