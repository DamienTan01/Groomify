import 'package:flutter/material.dart';

class GroomerNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const GroomerNavBar({super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xffD1B3C4),
      currentIndex: selectedIndex,
      iconSize: 35,
      unselectedItemColor: const Color(0xff735D78),
      selectedItemColor: Colors.black,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Manage',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
