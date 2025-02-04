import 'dart:convert'; // To handle JSON
import 'dart:io'; // For file handling
import 'package:dio/dio.dart'; // To download files
import 'package:path_provider/path_provider.dart'; // To access cache directory
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pdf_search_bar.dart'; // To display PDFs

class ReadOnlyPage extends StatefulWidget {
  const ReadOnlyPage({super.key});

  @override
  State<ReadOnlyPage> createState() => _ReadOnlyPageState();
}

class _ReadOnlyPageState extends State<ReadOnlyPage> {
  final _future = Supabase.instance.client
      .from('technicals_manuals')
      .select('id, name, file_url, key_word'); // Include key_word in the query

  List<dynamic> _allDocuments = [];
  List<dynamic> _filteredDocuments = [];
  List<dynamic> _favoriteDocuments = [];
  List<String> _favoriteIds = [];
  String _searchQuery = '';
  bool _showFavorites = false;

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
    _loadFavorites();
  }

  Future<void> _fetchDocuments() async {
    try {
      final response = await _future;
      setState(() {
        _allDocuments = response as List<dynamic>;
        _filteredDocuments = _allDocuments;
        _updateFavoriteDocuments();
      });
    } catch (e) {
      // Handle errors if necessary
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _favoriteIds = prefs.getStringList('favorites') ?? [];
        _updateFavoriteDocuments();
      });
    } catch (e) {
      // Handle errors if necessary
    }
  }

  Future<void> _toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
      _updateFavoriteDocuments();
    });
    await prefs.setStringList('favorites', _favoriteIds);
  }

  void _updateFavoriteDocuments() {
    _favoriteDocuments = _allDocuments
        .where((doc) => _favoriteIds.contains(doc['id']))
        .toList();
  }

  void _filterDocuments(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (query.isEmpty) {
        _filteredDocuments = _allDocuments;
      } else {
        _filteredDocuments = _allDocuments.where((doc) {
          final name = (doc['name'] ?? '').toLowerCase();
          if (name.contains(_searchQuery)) {
            return true;
          }

          final keyWords = doc['key_word'];
          if (keyWords != null) {
            try {
              final List<dynamic> parsedKeywords =
                  keyWords is String ? jsonDecode(keyWords) : keyWords;
              return parsedKeywords.any((keyword) =>
                  keyword.toString().toLowerCase().contains(_searchQuery));
            } catch (e) {
              // Ignore parsing errors
            }
          }

          return false;
        }).toList();
      }
    });
  }

  /// Downloads a document and saves it to the cache
  Future<File> _downloadDocument(
    String url,
    String filename, {
    Function(int, int)? onProgress,
  }) async {
    try {
      // Clean the filename to avoid long file name errors
      final cleanFilename = filename.split('?').first; // Remove query parameters

      // Get the cache directory
      final cacheDir = await getTemporaryDirectory();
      final filePath = '${cacheDir.path}/$cleanFilename';

      final file = File(filePath);
      if (await file.exists()) {
        return file; // Return the file if already downloaded
      }

      final dio = Dio();
      final response = await dio.download(
        url,
        filePath,
        onReceiveProgress: onProgress, // Track download progress
      );

      if (response.statusCode == 200) {
        return file;
      } else {
        throw Exception('Download failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error while downloading: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TM App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('All Technical Manuals'),
              onTap: () {
                setState(() {
                  _showFavorites = false;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () {
                setState(() {
                  _showFavorites = true;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                onChanged: _filterDocuments,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search ...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          // Document list
          Expanded(
            child: _showFavorites
                ? _buildDocumentList(_favoriteDocuments, "No favorites yet.")
                : _buildDocumentList(_filteredDocuments, "No documents found."),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentList(List<dynamic> documents, String emptyMessage) {
    if (documents.isEmpty) {
      return Center(
        child: Text(emptyMessage),
      );
    }

    return ListView.separated(
      itemCount: documents.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final document = documents[index];
        final id = document['id'];
        final name = document['name'] ?? 'Unknown name';
        final url = document['file_url'];
        final isFavorite = _favoriteIds.contains(id);

        return ListTile(
          title: Text(name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () => _toggleFavorite(id),
              ),
              IconButton(
                icon: const Icon(Icons.download, color: Colors.blue),
                onPressed: () async {
                  if (url != null && Uri.tryParse(url)?.hasAbsolutePath == true) {
                    final filename = url.split('/').last;
                    _downloadDocument(url, filename); // Télécharge le document
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid URL for this file.')),
                    );
                  }
                },
              ),
            ],
          ),
          onTap: () {
            // Ouvre le fichier local s'il est téléchargé, sinon en ligne
            if (url != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfSearchBar(url: url),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invalid URL for this file.')),
              );
            }
          },
        );
      },
    );
  }
}
