import 'package:flutter/material.dart';
import 'package:tm_app/models/document.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentCard extends StatefulWidget {
  final technicals_manuals document;

  const DocumentCard({super.key, required this.document});

  @override
  State<DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<DocumentCard> {
  bool isFavorite = false;
  bool _hasError = false;
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _checkIfFavorite();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      isFavorite = favorites.contains(widget.document.id);
    });
  }

  void _toggleFavorite() async {
    if (isFavorite) {
      await technicals_manuals.removeDocumentFromFavorites(widget.document);
    } else {
      await technicals_manuals.addDocumentToFavorites(widget.document);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Contenu principal (titre et mots-clés)
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.document.name,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: _toggleFavorite,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      children: widget.document.key_word.map((keyword) {
                        return Chip(
                          label: Text(
                            keyword,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.all(4),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            // Aperçu PDF
            Container(
              width: 120,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: _hasError
                    ? const Center(
                        child: Icon(
                          Icons.picture_as_pdf,
                          size: 40,
                          color: Colors.grey,
                        ),
                      )
                    : SfPdfViewer.network(
                        widget.document.file_url,
                        controller: _pdfViewerController,
                        pageSpacing: 0,
                        initialZoomLevel: 0.5,
                        enableDoubleTapZooming: false,
                        interactionMode: PdfInteractionMode.pan,
                        canShowScrollHead: false,
                        canShowScrollStatus: false,
                        canShowPaginationDialog: false,
                        onDocumentLoadFailed:
                            (PdfDocumentLoadFailedDetails details) {
                          setState(() {
                            _hasError = true;
                          });
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
