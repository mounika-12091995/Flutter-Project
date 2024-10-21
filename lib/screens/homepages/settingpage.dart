import 'package:flutter/material.dart';



class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationEnabled = true;
  bool _isFaceIDEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.orangeAccent, // Background color of the AppBar
      ),
      body: Column(
        children: [
          // Notification toggle
          SwitchListTile(
            title: Row(
              children: [
                Icon(Icons.notifications, color: Colors.black), // Notification Icon
                SizedBox(width: 8), // Spacing between icon and text
                Text('Notification:', style: TextStyle(fontSize: 16)),
              ],
            ),
            value: _isNotificationEnabled,
            onChanged: (bool value) {
              setState(() {
                _isNotificationEnabled = value;
              });
            },
            activeColor: Colors.green, // Color of the toggle when active
            contentPadding: EdgeInsets.symmetric(horizontal: 16), // Adjust the padding
          ),
          Divider(), // Line separator between options

          // Face ID toggle
          SwitchListTile(
            title: Row(
              children: [
                Icon(Icons.face_retouching_natural, color: Colors.black), // Face ID Icon
                SizedBox(width: 8), // Spacing between icon and text
                Text('Face ID:', style: TextStyle(fontSize: 16)),
              ],
            ),
            value: _isFaceIDEnabled,
            onChanged: (bool value) {
              setState(() {
                _isFaceIDEnabled = value;
              });
            },
            activeColor: Colors.green, // Color of the toggle when active
            contentPadding: EdgeInsets.symmetric(horizontal: 16), // Adjust the padding
          ),
        ],
      ),
    );
  }
}
