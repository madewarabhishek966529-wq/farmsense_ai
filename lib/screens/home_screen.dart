import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'suppliers_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  final String language;
  const HomeScreen({super.key, required this.language});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      ScanScreen(language: widget.language),
      HistoryScreen(language: widget.language),
      SuppliersScreen(language: widget.language),
      ChatScreen(language: widget.language),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF2D7A3A).withOpacity(0.15),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.camera_alt_outlined),
              selectedIcon: const Icon(Icons.camera_alt, color: Color(0xFF2D7A3A)),
              label: 'Scan',
              tooltip: 'Scan Crop',
            ),
            NavigationDestination(
              icon: const Icon(Icons.history_outlined),
              selectedIcon: const Icon(Icons.history, color: Color(0xFF2D7A3A)),
              label: 'History',
            ),
            NavigationDestination(
              icon: const Icon(Icons.store_outlined),
              selectedIcon: const Icon(Icons.store, color: Color(0xFF2D7A3A)),
              label: 'Suppliers',
            ),
            NavigationDestination(
              icon: const Icon(Icons.chat_bubble_outline),
              selectedIcon: const Icon(Icons.chat_bubble, color: Color(0xFF2D7A3A)),
              label: 'Ask AI',
            ),
          ],
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
    );
  }
}
