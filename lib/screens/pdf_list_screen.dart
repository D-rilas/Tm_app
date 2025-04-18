import 'package:flutter/material.dart';
import 'package:pdffinder/models/pdf_document.dart';
import 'package:pdffinder/screens/pdf_viewer_screen.dart';

class PDFListScreen extends StatefulWidget {
  const PDFListScreen({super.key});

  @override
  State<PDFListScreen> createState() => _PDFListScreenState();
}

class _PDFListScreenState extends State<PDFListScreen> {
  List<PdfDocument> pdfDocuments = [
    PdfDocument(
        id: "1",
        name: "Sample PDF 1",
        url: "https://www.africau.edu/images/default/sample.pdf",
        keywords: ["sample", "document", "one"]),
    PdfDocument(
        id: "2",
        name: "Another PDF Example",
        url: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
        keywords: ["example", "pdf", "two"]),
  ];

  List<PdfDocument> filteredDocuments = [];

  @override
  void initState() {
    super.initState();
    filteredDocuments = List.from(pdfDocuments);
  }

  void filterPDFs(String query) {
    setState(() {
      filteredDocuments = pdfDocuments
          .where((doc) =>
              doc.name.toLowerCase().contains(query.toLowerCase()) ||
              doc.keywords.any((keyword) =>
                  keyword.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDFinder'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search PDFs...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: filterPDFs,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredDocuments.length,
        itemBuilder: (context, index) {
          final document = filteredDocuments[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(document.name),
              subtitle: Text('Keywords: ${document.keywords.join(", ")}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.teal),
                    onPressed: () {
                      // TODO: Implement download functionality
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFViewerScreen(pdfUrl: document.url),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
