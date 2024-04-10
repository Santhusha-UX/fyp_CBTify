// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'cbt_challenge.dart';
import 'home_page.dart';
import 'journal_page.dart';
import 'profile_page.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  void _onTap(int index) {
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).bottomAppBarColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          NavBarItem(
            icon: Icons.home,
            title: 'Home',
            isActive: widget.selectedIndex == 0,
            onTap: () => _onTap(0),
          ),
          NavBarItem(
            icon: Icons.gamepad,
            title: 'Challenge',
            isActive: widget.selectedIndex == 1,
            onTap: () => _onTap(1),
          ),
          NavBarItem(
            icon: Icons.book,
            title: 'Journal',
            isActive: widget.selectedIndex == 2,
            onTap: () => _onTap(2),
          ),
          NavBarItem(
            icon: Icons.account_circle,
            title: 'Profile',
            isActive: widget.selectedIndex == 3,
            onTap: () => _onTap(3),
          ),
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? Theme.of(context).hintColor : Theme.of(context).secondaryHeaderColor, size: isActive ? 30 : 24),
            Text(title, style: TextStyle(fontSize: isActive ? 12 : 11, color: isActive ? Theme.of(context).hintColor : Theme.of(context).secondaryHeaderColor, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ChallengePage(),
    JournalPage(),
    const UserProfileScreen(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
