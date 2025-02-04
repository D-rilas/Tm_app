import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfSearchBar extends StatefulWidget {
  final String url;

  const PdfSearchBar({required this.url, super.key});

  @override
  State<PdfSearchBar> createState() => _PdfSearchBarState();
}

class _PdfSearchBarState extends State<PdfSearchBar> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  PdfTextSearchResult _searchResult = PdfTextSearchResult();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isDocumentLoaded = false; // Indicates if the document is loaded

  /// Launches a search within the entire PDF document
  void _searchText(String query) async {
    if (query.isNotEmpty) {
      try {
        // Perform the search within the document
        _searchResult = _pdfViewerController.searchText(query);

        // Listener to update search results
        _searchResult.addListener(() {
          setState(() {});
        });
      } catch (e) {
        // Displays an error message in case of an issue
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error while searching: $e')),
        );
      }
    }
  }

  /// Clears the current search
  void _clearSearch() {
    _searchController.clear();
    _pdfViewerController.clearSelection();
    setState(() {
      _searchResult.clear(); // Resets search results
      _isSearching = false; // Closes the search bar
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchResult.removeListener(() {}); // Clean up listeners
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TM Viewer'), // Custom title
        actions: [
          // Shows the search icon only when the document is loaded
          if (_isDocumentLoaded)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isSearching ? 250 : 50,
              child: Row(
                children: [
                  if (_isSearching)
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: _searchText, // Triggers the search
                        autofocus: true,
                      ),
                    ),
                  IconButton(
                    icon: Icon(
                      _isSearching ? Icons.close : Icons.search,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_isSearching) {
                          _clearSearch(); // Clears the search and closes the bar
                        } else {
                          _isSearching = true; // Opens the search bar
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // PDF Viewer with vertical continuous scrolling
          SfPdfViewer.network(
            widget.url,
            controller: _pdfViewerController,
            pageLayoutMode: PdfPageLayoutMode.continuous, // Vertical scrolling
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() {
                _isDocumentLoaded = true;
              });
            },
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              // Error handling if document loading fails
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to load PDF: ${details.error}'),
                ),
              );
            },
          ),
          // Floating widget for search results
          if (_searchResult.hasResult)
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Previous button
                    IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: () {
                        if (_searchResult.currentInstanceIndex > 1) {
                          _searchResult.previousInstance();
                        }
                      },
                    ),
                    // Number of results
                    Text(
                      '${_searchResult.currentInstanceIndex}/${_searchResult.totalInstanceCount}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    // Next button
                    IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      onPressed: () {
                        if (_searchResult.currentInstanceIndex <
                            _searchResult.totalInstanceCount) {
                          _searchResult.nextInstance();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
