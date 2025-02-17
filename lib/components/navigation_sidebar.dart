import 'package:flutter/material.dart';

class NavigationSidebar extends StatefulWidget {
  const NavigationSidebar({super.key});

  @override
  State<NavigationSidebar> createState() => _NavigationSidebarState();
}

class _NavigationSidebarState extends State<NavigationSidebar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: double.infinity,
              child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      'Sen Stops',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  )),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Les arrêts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/arrets');
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_bus),
              title: const Text('Lignes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/lignes');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Modifier l'arrêt"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/update_arret');
              },
            ),
            const Divider(color: Colors.black54),
          ],
        ),
      ),
    );
  }
}