import 'dart:convert';

import 'package:Shubhvite/Common/appcolors.dart';
import 'package:Shubhvite/Common/primary_Button.dart';
import 'package:Shubhvite/screens/homepages/dropdown_menu.dart';
import 'package:Shubhvite/screens/homepages/tabbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:Shubhvite/Common/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Shubhvite/model/api_calls.dart';

class Invit_pepole extends StatefulWidget {
  final String eventTitle;
  final String eventType;
  final String eventDate;
  final String location;
  final String enteredText;
  final String eventID;
  final String remainderDays;
  final String isEnabled;
  final String selectedDate;
  final List<Contact> selectedContacts;
  final List<Contact> massage;
  final List<Contact> email;
  final List<Contact> whatsapp;
  final int lenth;

  Invit_pepole(
      {required this.eventTitle,
      required this.eventType,
      required this.eventDate,
      required this.location,
      required this.enteredText,
      required this.eventID,
      required this.remainderDays,
      required this.isEnabled,
      required this.selectedDate,
      required this.massage,
      required this.email,
      required this.lenth,
      required this.selectedContacts,
      required this.whatsapp});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<Invit_pepole> {
  // List<Contact> _selectedMessageContacts = [];
  // List<Contact> _selectedEmailContacts = [];

  TextEditingController _searchController = TextEditingController();

  List<Color> avatarColors = [
    const Color.fromARGB(158, 244, 67, 54),
    const Color.fromARGB(158, 33, 149, 243),
    const Color.fromARGB(162, 76, 175, 79),
    const Color.fromARGB(144, 254, 220, 47),
    const Color.fromARGB(154, 255, 64, 128),
    // Add more colors as needed
  ];
  bool isMenuOpen = false;

  var whatsapp = false;
  var message = false;
  var email = false;

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  bool _isAscending = true;

  void _sortContacts() {
    setState(() {
      widget.selectedContacts.sort((a, b) {
        if (_isAscending) {
          return (a.displayName ?? '').compareTo(b.displayName ?? '');
        } else {
          return (b.displayName ?? '').compareTo(a.displayName ?? '');
        }
      });
    });
  }

  Future<void> _handleTokenRefresh() async {
    try {
      String? refreshToken = await getData('refreshToken');
      if (refreshToken != null) {
        Map<String, dynamic> response =
            await apiService.refreshToken(refreshToken);

        if (response['status'] == 200) {
          Map<String, dynamic> data = response['data']['data'];

          String newToken = data["token"];
          String userId = data["userId"];
          String newRefreshToken = data["refreshToken"];

          // Save new tokens
          await saveData('token', newToken);
          await saveData('userId', userId);
          await saveData('refreshToken', newRefreshToken);
        } else {
          print("Failed to refresh token: ${response['status']}");
        }
      }
    } catch (error) {
      print("Failed to refresh token: $error");
    }
  }

  Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> _sendDataToBackend() async {
    String? authToken = await getData('token');

    List<Map<String, dynamic>> eventInvitationDtos = [];

    List<Contact> mahesh = widget.email + widget.massage + widget.whatsapp;
    for (final contact in mahesh) {
      eventInvitationDtos.add({
        'invitationVideoUrl': null,
        'phoneNo': contact.phones?.isNotEmpty == true
            ? contact.phones!.first.value!
            : '',
        'receiverEmail': contact.emails?.isNotEmpty == true
            ? contact.emails!.first.value!
            : '',
        'contactName': contact.displayName ?? '',
        'remainderDays': widget.remainderDays,
        'invitationStatus': null,
        'comments': null,
        'whatsApp': widget.whatsapp.contains(contact),
        'email': widget.email.contains(contact),
        'sms': widget.massage.contains(contact),
      });
    }
    Map<String, dynamic> data = {
      "eventTransactionId": widget.eventID,
      "remainderRequired": widget.isEnabled,
      "remainderDate": widget.selectedDate,
      'eventInvitationDtos': eventInvitationDtos
    };

    print('Request Data : $data');

    final response = await http.post(
      Uri.parse('http://13.50.58.181:8085/event/sendEvent'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(data),
    );

    print("Response body : ${response.body}");
    Map<String, dynamic> parsedData = jsonDecode(response.body);
    // String message = responseData["message"].toString();
    print("Error: ${response.statusCode}");
    String message = parsedData["message"].toString();

    if (response.statusCode == 200) {
      showToast(context, message);
      print('Data sent successfully');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => GlobalTabScreen(),
          ),
          (route) => false);
    } else {
      String errorMsg = parsedData["data"]["message"].toString();
      print("message $errorMsg");

      if (errorMsg == "Expired Token") {
        _handleTokenRefresh();
      }

      print('Failed to send data. Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Selected contacts',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Appcolors.primary,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      endDrawer: Dropdown_menu(),
      backgroundColor: Colors.white, // Set the background color

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Selected contact list                                               ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder(
                    horizontalInside:
                        BorderSide(color: Colors.grey), // Only row lines
                    top: BorderSide(color: Colors.grey), // Top border
                    bottom: BorderSide(color: Colors.grey), // Bottom border
                    left: BorderSide(color: Colors.grey), // Left column border
                    right:
                        BorderSide(color: Colors.grey), // Right column border
                  ),
                  columnWidths: {
                    0: const FixedColumnWidth(
                        30.0), // Adjust column widths as needed
                    1: const FixedColumnWidth(30.0),
                    2: const FixedColumnWidth(190.0),
                    3: const FixedColumnWidth(30.0),
                    4: const FixedColumnWidth(30.0),
                    5: const FixedColumnWidth(30.0),
                  },
                  children: [
                    // Table header row
                    TableRow(children: [
                      TableCell(
                          child: Center(
                              child: Text(''))), // Checkbox column header
                      TableCell(
                          child: Center(
                              child: Text('#',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                      TableCell(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isAscending = !_isAscending;
                              _sortContacts();
                            });
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Name'),
                                Icon(
                                  _isAscending
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                          child: Center(
                              child: Image.asset(
                        'assets/whatsapp.png',
                        fit: BoxFit.cover,
                        width: 20,
                        height: 20,
                      ))),
                      TableCell(
                          child: Center(
                              child: Image.asset(
                        'assets/email.png',
                        fit: BoxFit.cover,
                        width: 20,
                        height: 20,
                      ))),
                      TableCell(
                          child: Center(
                              child: Image.asset(
                        'assets/massage.png',
                        fit: BoxFit.cover,
                        width: 20,
                        height: 20,
                      ))),
                    ]),
                    // Table rows from your ListView.builder
                    for (int i = 0; i < widget.selectedContacts.length; i++)
                      TableRow(children: [
                        TableCell(
                          child: Center(
                            child: Checkbox(
                              value: true, // Replace with actual value
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    // Handle checkbox change
                                  } else {
                                    // Handle checkbox change
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        TableCell(
                            child: Center(
                                heightFactor: 2.5, child: Text('${i + 1}'))),
                        TableCell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 14,
                              ),
                              Text(
                                  widget.selectedContacts[i].displayName ?? ''),
                            ],
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Checkbox(
                              value: widget.whatsapp
                                  .contains(widget.selectedContacts[i]),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    // Handle checkbox change
                                  } else {
                                    // Handle checkbox change
                                  }
                                });
                              },
                            ),
                          ), // Placeholder for phone column
                        ),
                        TableCell(
                          child: Center(
                            child: Checkbox(
                              value: widget.email
                                  .contains(widget.selectedContacts[i]),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    // Handle checkbox change
                                  } else {
                                    // Handle checkbox change
                                  }
                                });
                              },
                            ),
                          ), // Placeholder for phone column
                        ),
                        TableCell(
                          child: Center(
                            child: Checkbox(
                              value: widget.massage
                                  .contains(widget.selectedContacts[i]),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    // Handle checkbox change
                                  } else {
                                    // Handle checkbox change
                                  }
                                });
                              },
                            ),
                          ), // Placeholder for phone column
                        ),
                      ]),
                  ],
                ),
              ),
            ),
            Container(
              width: 330,
              height: 180,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.elliptical(25, 29))),
              child: Column(children: [
                Text(
                  'Inviting ${widget.massage.length + widget.email.length + widget.whatsapp.length} out of ${widget.lenth} contact',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                Text('from your list',
                    style: TextStyle(color: Colors.white, fontSize: 17)),
                _buildSelectedCounts(),
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            GradientButton(
              onPressed: () async {
                if (widget.email.length >= 1 ||
                    widget.massage.length >= 1 ||
                    widget.whatsapp.length >= 1) {
                  await _sendDataToBackend();
                } else {
                  showToast(context, "pls select atleast one contact");
                }
              },
              text: 'Send',
              gradient: LinearGradient(
                colors: Appcolors.buttoncolors,
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedCounts() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSelectedCount(Icons.message, widget.massage.length),
          _buildSelectedCount(Icons.mail, widget.email.length),
          _buildSelect('assets/whatsapp2.png', widget.whatsapp.length),
        ],
      ),
    );
  }

  Widget _buildSelectedCount(IconData iconData, int count) {
    return Column(
      children: [
        Icon(
          iconData,
          size: 30,
          color: Colors.white,
        ),
        SizedBox(height: 4),
        Text(
          '$count',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSelect(String image, int count) {
    return Column(
      children: [
        Image.asset(
          image,
          width: 30,
          height: 30,
        ),
        SizedBox(height: 4),
        Text(
          '$count',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }

  void _toggleMessageContactSelection(Contact contact) {
    setState(() {
      if (widget.massage.contains(contact)) {
        widget.massage.remove(contact);
      } else {
        if (widget.email.contains(contact)) {
          widget.email.remove(contact);
        }
        widget.massage.add(contact);
      }
    });
    print('Message: ${widget.massage.contains(contact)}');
  }

  void _toggleEmailContactSelection(Contact contact) {
    setState(() {
      if (widget.email.contains(contact)) {
        widget.email.remove(contact);
      } else {
        if (widget.massage.contains(contact)) {
          widget.massage.remove(contact);
        }
        widget.email.add(contact);
      }
    });
    print('Email: ${widget.email.contains(contact)}');
  }
}
