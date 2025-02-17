import 'package:flutter/material.dart';
import 'package:tm_app/models/document.dart';
import 'package:tm_app/components/documentCard.dart';
import 'package:tm_app/services/document_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<technicals_manuals> documents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    try {
      final docs = await DocumentService.getAllDocuments();
      setState(() {
        documents = docs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error loading documents.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : documents.isEmpty
            ? const Center(
                child: Text('No document available'),
              )
            : RefreshIndicator(
                onRefresh: _loadDocuments,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    return DocumentCard(document: documents[index]);
                  },
                ),
              );
  }
}
