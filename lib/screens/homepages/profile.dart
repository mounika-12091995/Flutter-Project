import 'package:flutter/material.dart';
import 'package:Shubhvite/Common/appcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatelessWidget {
  Future<String?> getData(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Appcolors.primary,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 280,
            width: 440,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Appcolors.primary,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 40),
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: 30),
                FutureBuilder<String?>(
                  future: getData('firstName'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        'Loading...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return Text(
                        '', // fallback or default name
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    } else {
                      return Text(
                        snapshot.data ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(19.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Profile',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                buildProfileDetail("Name", getData('firstName')),
                SizedBox(height: 20),
                buildProfileDetail("User name", getData('email')),
                SizedBox(height: 20),
                buildProfileDetail("Password", Future.value("**********")),
                SizedBox(height: 20),
                buildProfileDetail("Email ID", getData('email')),
                SizedBox(height: 20),
                buildProfileDetail("Mobile number", getData('phoneNo')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileDetail(String title, Future<String?> futureValue) {
    return FutureBuilder<String?>(
      future: futureValue,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title: Loading...",
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: "calibri",
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title: Error",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontFamily: "calibri",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text('${snapshot.data ?? 'Not available'}')
            ],
          );
        }
      },
    );
  }
}
