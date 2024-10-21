import 'package:flutter/material.dart';
import 'package:Shubhvite/screens/homepages/even_createpage.dart';
import 'package:Shubhvite/screens/homepages/events_list.dart';
import 'package:Shubhvite/screens/homepages/notificationpage.dart';
import 'package:Shubhvite/screens/homepages/settingpage.dart';

class GlobalTabScreen extends StatefulWidget {
  const GlobalTabScreen({super.key});

  @override
  State<GlobalTabScreen> createState() => _GlobalTabScreenState();
}

class _GlobalTabScreenState extends State<GlobalTabScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const EventScreenList();

    if (_currentIndex == 1) {
      activePage = const EventcreatePages();
    } else if (_currentIndex == 2) {
      activePage = SettingsScreen();
    } else if (_currentIndex == 3) {
      activePage = const Notificationpage();
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onTabSelected,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_invitation),
            label: 'Create Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add_outlined),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
