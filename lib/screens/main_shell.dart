import 'package:flutter/material.dart';
import 'home.dart';
import 'startup_dashboard.dart';
import 'profile_page.dart';
import 'settings.dart';

class MainShell extends StatefulWidget {
  final String role; // 'student' or 'startup'

  const MainShell({super.key, required this.role});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isStudent = widget.role != 'startup';

    final screens = [
      isStudent ? const HomeScreen() : const StartupDashboardScreen(),
      const ProfilePage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              isStudent ? Icons.explore_outlined : Icons.dashboard_outlined,
            ),
            activeIcon: Icon(isStudent ? Icons.explore : Icons.dashboard),
            label: isStudent ? 'Discover' : 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
