import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class technicals_manuals {
  final String id;
  final String name;
  final String file_url;
  final String type;
  final DateTime created_at;
  final List<String> key_word;

  technicals_manuals({
    required this.id,
    required this.name,
    required this.file_url,
    required this.type,
    required this.created_at,
    required this.key_word,
  });

  factory technicals_manuals.fromJson(Map<String, dynamic> json) {
    return technicals_manuals(
      id: json['id'],
      name: json['name'],
      file_url: json['file_url'],
      type: json['type'],
      created_at: DateTime.parse(json['created_at']),
      key_word: json['key_word'],
    );
  }

  static List<technicals_manuals> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => technicals_manuals.fromJson(json)).toList();
  }

  // fonction pour récupérer tout les documents depuis supabase
  static Future<List<technicals_manuals>> getAllDocuments() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('technicals_manuals').select('*');
    print(technicals_manuals.fromJsonList(response));
    return technicals_manuals.fromJsonList(response);
  }

  // fonction pour récupérer un document depuis supabase
  static Future<technicals_manuals> getDocument(String id) async {
    final supabase = Supabase.instance.client;
    final response =
        await supabase.from('technicals_manuals').select('*').eq('id', id);
    return technicals_manuals.fromJson(response[0]);
  }

  // fonction pour récupérer les documents depuis supabase en fonction d'un mot clé
  static Future<List<technicals_manuals>> getDocumentsByKeyword(
      String keyword) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('technicals_manuals')
        .select('*')
        .eq('key_word', keyword);
    return fromJsonList(response);
  }

  // fonction pour récupérer les documents depuis supabase en fonction d'un type
  static Future<List<technicals_manuals>> getDocumentsByType(
      String type) async {
    final supabase = Supabase.instance.client;
    final response =
        await supabase.from('technicals_manuals').select('*').eq('type', type);
    return fromJsonList(response);
  }

  // fonction pour récupérer les documents depuis supabase en fonction d'un mot clé et d'un type
  static Future<List<technicals_manuals>> getDocumentsByKeywordAndType(
      String keyword, String type) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('technicals_manuals')
        .select('*')
        .eq('key_word', keyword)
        .eq('type', type);
    return fromJsonList(response);
  }

  // fontion pour récupérer un document en fonction du nom
  static Future<technicals_manuals> getDocumentByName(String name) async {
    final supabase = Supabase.instance.client;
    final response =
        await supabase.from('technicals_manuals').select('*').eq('name', name);
    return technicals_manuals.fromJson(response[0]);
  }

  // ajouter un document comme favoris avec shared_preferences
  static Future<void> addDocumentToFavorites(
      technicals_manuals document) async {
    // Implementation for adding to favorites
  }

  // supprimer un document des favoris avec shared_preferences
  static Future<void> removeDocumentFromFavorites(
      technicals_manuals document) async {
    // Implementation for removing from favorites
  }
}
