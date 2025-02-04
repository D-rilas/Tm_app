import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pdf_viewer_page.dart'; // Assurez-vous que le chemin est correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Supabase avec gestion des erreurs
  try {
    await Supabase.initialize(
      url:
          'https://wihqbdsjrbzcctpiotfb.supabase.co', // Remplacez par votre URL Supabase
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndpaHFiZHNqcmJ6Y2N0cGlvdGZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU2Mzc1MDgsImV4cCI6MjA1MTIxMzUwOH0.Rz2_1QkLX9JNe0QrVyqwD4wUezv5mZm1o86cPRUA5II', // Remplacez par votre clé anonyme
    );
    debugPrint('Supabase initialisé avec succès.');
  } catch (e) {
    debugPrint('Erreur d\'initialisation Supabase : $e');
    // Optionnel : Vous pouvez afficher une alerte ou arrêter l'exécution
    throw Exception('Échec de l\'initialisation de Supabase.');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Document Viewer',
      debugShowCheckedModeBanner: false, // Supprime la debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          const ReadOnlyPage(), // Assurez-vous que cette page est correctement implémentée
    );
  }
}
