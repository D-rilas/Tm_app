import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tm_app/pages/home.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Documentation Technique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text('Favoris')),
    const Center(child: Text('Settings')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documentation Technique'),
      ),
      body: Row(
        children: [
          // NavigationRail(
          //   extended: MediaQuery.of(context).size.width >= 800,
          //   destinations: const [
          //     NavigationRailDestination(
          //       icon: Icon(Icons.home_outlined),
          //       selectedIcon: Icon(Icons.home),
          //       label: Text('Home'),
          //     ),
          //     NavigationRailDestination(
          //       icon: Icon(Icons.favorite_outline),
          //       selectedIcon: Icon(Icons.favorite),
          //       label: Text('Favorites'),
          //     ),
          //     NavigationRailDestination(
          //       icon: Icon(Icons.settings_outlined),
          //       selectedIcon: Icon(Icons.settings),
          //       label: Text('Settings'),
          //     ),
          //   ],
          //   selectedIndex: _selectedIndex,
          //   onDestinationSelected: _onItemTapped,
          // ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      // Pour les écrans mobiles, ajout d'une bottom navigation bar
      bottomNavigationBar: MediaQuery.of(context).size.width < 640
          ? NavigationBar(
              onDestinationSelected: _onItemTapped,
              selectedIndex: _selectedIndex,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_outline),
                  selectedIcon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            )
          : null,
    );
  }
}
