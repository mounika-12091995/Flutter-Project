import 'dart:convert';

import 'package:Shubhvite/global/appcolors.dart';
import 'package:http/http.dart' as http;
import 'package:Shubhvite/screens/authenticationpage/loginpage.dart';
import 'package:Shubhvite/screens/homepages/even_createpage.dart';
import 'package:Shubhvite/screens/homepages/notificationpage.dart';
import 'package:Shubhvite/screens/homepages/profile.dart';
import 'package:Shubhvite/screens/homepages/settingpage.dart';
import 'package:Shubhvite/screens/homepages/tabbar.dart';
import 'package:Shubhvite/screens/homepages/update_mobilenum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dropdown_menu extends ConsumerStatefulWidget {
  @override
  _Dropdown_menuState createState() => _Dropdown_menuState();
}

class _Dropdown_menuState extends ConsumerState<Dropdown_menu> {
  String? email;
  String? name;
  List<Map<String, dynamic>> eventList = [];
  Map<String, dynamic>? selectedEvent;

  @override
  void initState() {
    super.initState();
    Countysget();
    _fetchData(); // Fetch data when the widget is initialized
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email") ?? "No Email";
      name = prefs.getString("firstName") ?? "User";
    });
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.red[400],
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: DropdownButtonFormField<Map<String, dynamic>>(
              value: selectedEvent,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: "Country",
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 246, 245, 245),
                    width: 1.0,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                fillColor:
                    const Color(0xffff8f), // Ensure color format is correct
                filled: true,
              ),
              onChanged: (Map<String, dynamic>? newValue) {
                setState(() {
                  selectedEvent = newValue;
                  print('Selected country: $selectedEvent');
                });
              },
              items: eventList.map<DropdownMenuItem<Map<String, dynamic>>>(
                  (Map<String, dynamic> value) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: value,
                  child: Text(
                    value['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      //  color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please select Country";
                }
                return null;
              },
            ),

            accountEmail: Text(""),
            decoration: BoxDecoration(color: Colors.red[400]
                // gradient: LinearGradient(
                //   colors: Appcolors.primary,
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                // ),
                ),
            // currentAccountPicture: CircleAvatar(
            //   backgroundColor: Colors.white,
            //   child: Text(
            //     name![0].toUpperCase(),
            //     style: TextStyle(fontSize: 20.0),
            //   ),
            // ),
          ),
          DrawerListItem(
            icon: Icons.person,
            title: 'My Profile',
            page: 0,
          ),
          DrawerListItem(
            icon: Icons.notification_add,
            title: 'Notifications',
            page: 1,
          ),
          DrawerListItem(
            icon: Icons.insert_invitation,
            title: 'Create event',
            page: 2,
          ),
          DrawerListItem(icon: Icons.settings, title: 'Settings', page: 3),
          DrawerListItem(
              icon: Icons.login_outlined, title: 'Sign out', page: 4),
        ],
      ),
    );
  }

  Future<void> Countysget() async {
    String url = 'https://ellostars.com/api/countries';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Basic ' + base64Encode(utf8.encode('ellostars:ellostars')),
        },
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print("country$result");
        setState(() {
          List<dynamic> data = result['details'];
          for (var item in data) {
            eventList.add({
              'id': item['id'],
              'name': item['name'],
            });
          }
        });
      } else {
        print('Not able to get countries');
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

class DrawerListItem extends ConsumerStatefulWidget {
  final IconData icon;
  final String title;
  final int page;

  const DrawerListItem({
    required this.icon,
    required this.title,
    required this.page,
    Key? key,
  }) : super(key: key);

  @override
  _DrawerListItemState createState() => _DrawerListItemState();
}

class _DrawerListItemState extends ConsumerState<DrawerListItem> {
  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> signOut() async {
    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Clear the login status in shared preferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LoginPage(), // Replace with your login page
                    ),
                    (route) => false);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _homepage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => GlobalTabScreen()));
  }

  void _Eventcreatepage() async {
    String? mobileNumber = await getData("phoneNo");
    if (mobileNumber == "+910000000000") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => updated_mobile()));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventcreatePages()),
      );
    }
  }

  void notificationpage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Notificationpage()));
  }

  void settingpage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }

  void profilepage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icon, color: Colors.white),
      title: Text(
        widget.title,
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer

        // Conditional navigation based on the selected page
        switch (widget.page) {
          case 0:
            profilepage();
            break;
          case 1:
            notificationpage();
            break;
          case 2:
            _Eventcreatepage();
            break;
          case 3:
            settingpage();
            break;
          case 4:
            signOut();
            break;
        }
      },
    );
  }
}
