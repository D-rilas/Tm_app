import 'package:flutter/material.dart';
import 'package:tm_app/components/navigation_sidebar.dart';

class BasePage extends StatelessWidget {
  final Widget child;

  const BasePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sen Stops', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: NavigationSidebar(
          //  changePage: (int? pageIndex) {
          // Implémentez la logique pour changer de page ici
          //},
          ),
      body: child,
    );
  }
}