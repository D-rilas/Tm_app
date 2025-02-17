import 'package:tm_app/models/document.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentService {
  static final supabase = Supabase.instance.client;

  static Future<List<technicals_manuals>> getAllDocuments() async {
    try {
      final response = await supabase
          .from('technicals_manuals')
          .select()
          .order('created_at', ascending: false);

      return response.map<technicals_manuals>((doc) {
        // Conversion explicite de List<dynamic> en List<String>
        List<String> keywords = [];
        if (doc['key_word'] != null) {
          keywords = List<String>.from(doc['key_word']);
        }

        return technicals_manuals(
          id: doc['id'],
          name: doc['name'],
          file_url: doc['file_url'],
          type: doc['type'],
          created_at: DateTime.parse(doc['created_at']),
          key_word: keywords,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch documents: $e');
    }
  }
}
