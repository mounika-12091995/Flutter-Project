import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:Shubhvite/global/appcolors.dart';
import 'package:Shubhvite/global/secound_primary_button.dart';
import 'package:Shubhvite/model/api_calls.dart';

import 'package:Shubhvite/screens/homepages/pastevent_list.dart';
import 'package:Shubhvite/screens/homepages/update_mobilenum.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Shubhvite/screens/homepages/dropdown_menu.dart';
import 'package:Shubhvite/screens/homepages/even_createpage.dart';
import 'package:Shubhvite/screens/homepages/Upcomming_events.dart';

class EventScreenList extends StatefulWidget {
  final mobileNumber;
  const EventScreenList({Key? key, this.mobileNumber}) : super(key: key);

  @override
  _EventScreenListState createState() => _EventScreenListState();
}

class _EventScreenListState extends State<EventScreenList> {
  Map<String, dynamic> responseData = {};
  var _isLoading = true;

  List<Map<String, dynamic>> pastEventsArray = [];
  List<Map<String, dynamic>> upcomingEventsArray = [];

  List<dynamic> archivedEventsArray = [];
  bool _isUpcomingExpanded = false;
  bool _isPastExpanded = false;
  Int? Statuscode;
  bool isMenuOpen = false;
  String isEnabled = "";

  @override
  void initState() {
    super.initState();
    _getMyEvents();
    pastEventsArray;
    upcomingEventsArray;
  }

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> _getMyEvents() async {
    try {
      String? userID = await getData('userId');
      String? authToken = await getData('token');
      print('token: $authToken');
      final response = await http.get(
        Uri.parse('http://13.50.58.181:8085/event/getEvents?userId=$userID'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> parsedData = jsonDecode(response.body);
        setState(() {
          responseData = parsedData;
          pastEventsArray =
              List<Map<String, dynamic>>.from(parsedData['data']['pastEvents']);
          upcomingEventsArray = List<Map<String, dynamic>>.from(
              parsedData['data']['upcomingEvents']);
          _isLoading = false;
        });
      } else if (response.statusCode == 204) {
        setState(() {
          pastEventsArray = [];
          upcomingEventsArray = [];
        });
      } else {
        setState(() {
          pastEventsArray = [];
          upcomingEventsArray = [];
          _isLoading = false;
          _refreshToken();
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print("An error occurred: $error");
    }
  }

  Future<void> _refreshToken() async {
    String? authToken = await getData('refreshToken');
    print('refreshToken: $authToken'); // Debug log for refresh token

    // Define the API endpoint
    String apiUrl = "http://13.50.58.181:8085/user/refreshToken";
    // Define the data to be sent in the request body
    Map<String, dynamic> data = {
      "token": authToken,
    };
    // Encode the data to JSON
    String requestBody = jsonEncode(data);

    // Make the POST request
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful, handle the response data
        print("Response: ${response.body}");
        Map<String, dynamic> parsedData = jsonDecode(response.body);
        setState(() {
          responseData = parsedData;
        });
        int status = responseData["status"];
        if (status == 200) {
          Map<String, dynamic> data = responseData["data"];
          String token = data["token"].toString();
          String userID = data["userId"].toString();
          String refreshToken = data["refreshToken"].toString();

          // Save data
          await saveData('token', token);
          await saveData('userId', userID);
          await saveData('refreshToken', refreshToken);

          _getMyEvents();
        } else {
          print("Error: ${responseData["message"]}");
        }
      } else {
        print("Error: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  // Save data
  Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_isLoading) {
      content = Center(
        child: CircularProgressIndicator(),
      );
    } else if (upcomingEventsArray.length > 0 || pastEventsArray.length > 0) {
      content = Column(
        children: [
          SizedBox(
            height: 15,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [

          //     doubleButton(
          //       onPressed: () async {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => ArchivedEvents()));
          //       },
          //       text: 'Archived events',
          //       gradient: LinearGradient(colors: Appcolors.buttoncolors),
          //     ),
          //   ],
          // ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            // Wrap ListView with Expanded
            child: ListView(
              children: [
                ExpansionTile(
                  title: Text(
                    "Upcoming events",
                    style: TextStyle(color: Color.fromARGB(255, 7, 143, 255)),
                  ),
                  initiallyExpanded: _isUpcomingExpanded,
                  onExpansionChanged: (value) {
                    setState(() {
                      _isUpcomingExpanded = value;
                      isEnabled = "true";
                      print("isEnabled$isEnabled");
                    });
                  },
                  children: _isUpcomingExpanded
                      ? _buildEventList(upcomingEventsArray)
                      : [],
                ),
                ExpansionTile(
                  title: Text(
                    "Past events",
                    style: TextStyle(
                      color: Color.fromARGB(255, 7, 143, 255),
                    ),
                  ),
                  initiallyExpanded: _isPastExpanded,
                  onExpansionChanged: (value) {
                    setState(() {
                      _isPastExpanded = value;
                      isEnabled = "false";
                      print("isEnabled$isEnabled");
                    });
                  },
                  children:
                      _isPastExpanded ? _pastEventList(pastEventsArray) : [],
                ),
              ],
            ),
          ),

          secoundButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventcreatePages()),
              );
            },
            text: 'Create event',
            gradient: LinearGradient(colors: Appcolors.buttoncolors),
          ),
        ],
      );
    } else {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              '"Nothing here yet:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'It seems there are no events to display.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '   time to fill up your calendar with ',
              style: TextStyle(fontSize: 16),
            ),
            Text('memorable events!"',
             style: TextStyle(fontSize: 16),

            ),
            
        
        
            SizedBox(height: 18),
            secoundButton(
              onPressed: () async {
                String? mobileNumber = await getData("phoneNo");
                print("updated number is {$mobileNumber}");
                if (mobileNumber == "+910000000000") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => updated_mobile()));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventcreatePages()),
                  );
                }
              },
              text: 'Create event',
              gradient: LinearGradient(colors: Appcolors.buttoncolors),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My events',
            style: TextStyle(
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
      backgroundColor: Colors.white,
      body: content,
    );
  }

  List<Widget> _buildEventList(List<Map<String, dynamic>> data) {
    return data.map((event) => _buildEventBox(event)).toList();
  }

  Future<http.Response> _getImageData(String imageURL) async {
    String? authToken = await getData('token');
    final response = await http.get(
      Uri.parse('http://13.50.58.181:8085/media/stream-image?key=$imageURL'),
      headers: {'Authorization': 'Bearer $authToken'},
    );
    return response;
  }

  Widget _buildEventBox(Map<String, dynamic> event) {
    return FutureBuilder<http.Response>(
      future: _getImageData(
          event['eventImageDtos'] != null && event['eventImageDtos'].isNotEmpty
              ? event['eventImageDtos'][0]['imageKey']
              : ''),
      builder: (context, snapshot) {

          final imageData = snapshot.data;
          Uint8List? imageBytes;

          if (imageData != null && imageData.statusCode == 200) {
            imageBytes = imageData.bodyBytes;
          } else {
            // Load the placeholder image from assets
            imageBytes = null;
          }

          return _buildEventBoxWithImage(event, imageBytes);
        
      },
    );
  }

  Widget _buildEventBoxWithImage(
      Map<String, dynamic> event, Uint8List? imageBytes) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 32, 31, 31)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: event['customHeight'] ?? 200.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black), // Add border
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              
              child: imageBytes != null
                  ? Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: event['customHeight'] ?? 200.0,
                    )
                  : Image.asset(
                      'assets/splash1.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: event['customHeight'] ?? 200.0,
                    ),
            ),
          ),
           if (imageBytes == null)
          Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        '${event['eventTitle']}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 18, color: Color.fromARGB(255, 37, 38, 39)),
                        const SizedBox(width: 15),
                        Text('${event['eventLocation'] ?? 'Not specified'}'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month,
                            size: 18, color: Color.fromARGB(255, 59, 60, 61)),
                        const SizedBox(width: 15),
                        Text('${event['eventDate'] ?? 'Not specified'}'),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    _navigateToEventDetails(
                        event, context, imageBytes, _isUpcomingExpanded);
                  },
                  icon: const Icon(Icons.arrow_forward),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _pastEventList(List<Map<String, dynamic>> data) {
    return data.map((event) => _pastEventBox(event)).toList();
  }

  Widget _pastEventBox(Map<String, dynamic> event) {
    return FutureBuilder<http.Response>(
      future: _getImageData(
          event['eventImageDtos'] != null && event['eventImageDtos'].isNotEmpty
              ? event['eventImageDtos'][0]['imageKey']
              : ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Placeholder while loading
        } else {
          final imageData = snapshot.data;
          Uint8List? imageBytes;

          if (imageData != null && imageData.statusCode == 200) {
            imageBytes = imageData.bodyBytes;
          } else {
            // Load the placeholder image from assets
            imageBytes = null;
          }

          return pastevent(event, imageBytes);
        }
      },
    );
  }

  Widget pastevent(Map<String, dynamic> event, Uint8List? imageBytes) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 32, 31, 31)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: event['customHeight'] ?? 200.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black), // Add border
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: imageBytes != null
                  ? Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: event['customHeight'] ?? 200.0,
                    )
                  : Image.asset(
                      'assets/splash1.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: event['customHeight'] ?? 200.0,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${event['eventTitle']}',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 18, color: Color.fromARGB(255, 37, 38, 39)),
                        const SizedBox(width: 15),
                        Text('${event['eventLocation'] ?? 'Not specified'}'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month,
                            size: 18, color: Color.fromARGB(255, 59, 60, 61)),
                        const SizedBox(width: 15),
                        Text('${event['eventDate'] ?? 'Not specified'}'),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    _pastEventDetails(
                        event, context, imageBytes, _isUpcomingExpanded);
                  },
                  icon: const Icon(Icons.arrow_forward),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _pastEventDetails(Map<String, dynamic> event, BuildContext context,
      Uint8List? imageBytes, bool _isUpcomingExpanded) {
    Map<String, String> eventDetails = {
      'id': event['id'].toString(),
      'eventTypeCode': event['eventTypeCode'].toString(),
      'eventTitle': event['eventTitle'].toString(),
      'eventLocation': event['eventLocation'].toString(),
      'eventDate': event['eventDate'].toString(),
      'aboutEvent': event['aboutEvent'].toString(),
    };

    // Handle customHeight parsing
    if (event.containsKey('customHeight')) {
      try {
        double customHeight = double.parse(event['customHeight'].toString());
        eventDetails['customHeight'] = customHeight.toString();
      } catch (e) {
        // Handle the exception, log an error, or provide a default value
        print('Error parsing double for customHeight: $e');
        // Provide a default value or handle the error appropriately
        eventDetails['customHeight'] = '200.0'; // You can use any default value
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PastDetailsScreen(
          event: eventDetails,

          imagebye: imageBytes ?? Uint8List(0), // Handle null case
        ),
      ),
    );
  }

  void _navigateToEventDetails(Map<String, dynamic> event, BuildContext context,
      Uint8List? imageBytes, bool _isUpcomingExpanded) {
    Map<String, String> eventDetails = {
      'id': event['id'].toString(),
      'eventTypeCode': event['eventTypeCode'].toString(),
      'eventTitle': event['eventTitle'].toString(),
      'eventLocation': event['eventLocation'].toString(),
      'eventDate': event['eventDate'].toString(),
      'aboutEvent': event['aboutEvent'].toString(),
    };

    // Handle customHeight parsing
    if (event.containsKey('customHeight')) {
      try {
        double customHeight = double.parse(event['customHeight'].toString());
        eventDetails['customHeight'] = customHeight.toString();
      } catch (e) {
        // Handle the exception, log an error, or provide a default value
        print('Error parsing double for customHeight: $e');
        // Provide a default value or handle the error appropriately
        eventDetails['customHeight'] = '200.0'; // You can use any default value
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(
          event: eventDetails,
          isEnable: isEnabled,
          imagebye: imageBytes ?? Uint8List(0), // Handle null case
        ),
      ),
    );
  }
}
