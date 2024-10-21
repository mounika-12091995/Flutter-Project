import 'dart:convert';
import 'dart:typed_data';
import 'package:Shubhvite/global/appcolors.dart';
import 'package:Shubhvite/global/secound_primary_button.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ArchivedEvents extends StatefulWidget {
  @override
  State<ArchivedEvents> createState() => _ArchivedEventsState();
}

class _ArchivedEventsState extends State<ArchivedEvents> {
  TextEditingController _searchController = TextEditingController();
  Map<String, dynamic> responseData = {};
  DateTime selectedDate = DateTime(2024);
  DateTime selectedDate2 = DateTime.now();
  bool isLoading = false;

  List<Map<String, dynamic>> archivedevents = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate2,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate2) {
      setState(() {
        selectedDate2 = picked;
      });
    }
  }

  void _navigateToEventDetails(
      Map<String, dynamic> event, BuildContext context) {
    // Map<String, String> eventDetails = {
    //   'eventTypeCode': event['eventTypeCode'].toString(),
    //   'eventLocation': event['eventLocation'].toString(),
    //   'eventDate': event['eventDate'].toString(),
    //   'aboutEvent': event['aboutEvent'].toString(),
    //   'eventImageDtos': event['eventImageDtos'] != null
    //       ? event['eventImageDtos'].toString()
    //       : '',
    // };
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => EventDetailsScreen(event: eventDetails),
    //   ),
    // );
  }

  @override
  void initState() {
    _getMyEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Archived events',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _searchController,
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: 'Search Events...',
                filled: true, // Set to true to enable background color
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: "${selectedDate.toLocal()}".split(' ')[0],
              ),
              decoration: InputDecoration(
                hintText: 'Choose from date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              onTap: () => _selectDate(context),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: "${selectedDate2.toLocal()}".split(' ')[0],
              ),
              decoration: InputDecoration(
                hintText: 'Choose to date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate2(context),
                ),
              ),
              onTap: () => _selectDate2(context),
            ),
            SizedBox(
              height: 30,
            ),
            secoundButton(
              onPressed: () async {
                await _getMyEvents();
              },
              text: 'Search',
              gradient: LinearGradient(
                colors: Appcolors.buttoncolors,
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : archivedevents.isEmpty
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 150,
                          ),
                          Text(
                            'No Records',
                            style: TextStyle(fontSize: 17),
                          )
                        ],
                      ))
                    : ListView.builder(
                        itemCount: archivedevents.length,
                        itemBuilder: (context, index) {
                          return _buildEventBox(archivedevents[index]);
                        },
                      ),
          ],
        ),
      ),
    );
  }

  Future<void> _getMyEvents() async {
    try {
      String? authToken = await getData('token');
      String? userID = await getData('userId');

      if (authToken == null || userID == null) {
        print('Error: authToken or userID is null');
        return;
      }

      print('Token: $authToken');
      String uri =
          'http://13.50.58.181:8085/event/getEvents?userId=$userID&fromDate=2024-01-01&toDate=2024-06-21&isArchived=true';
      print('URL: $uri');

      final response = await http.get(
        Uri.parse(uri),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      Map<String, dynamic> parsedData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("parsedData$parsedData");
        setState(() {
          responseData = parsedData;
          String message = parsedData["message"];
          showToast(context, message);
          if (message == "No records found") {
            archivedevents = [];
          } else {
            archivedevents = List<Map<String, dynamic>>.from(
                parsedData['data']["archivedEvents"]);
            print('Parsed Data: $archivedevents');
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print(
            'Error: Something went wrong, status code: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Exception: $error');
    }
  }

  void showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  Widget _buildEventAvatar(Map<String, dynamic> event, Uint8List? imageBytes) {
    return Container(
      height: event['customHeight'] ?? 110.0,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 18, 17, 17),
        ),
        borderRadius: BorderRadius.circular(11.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: event['eventImageDtos'] != null &&
                  event['eventImageDtos'].isNotEmpty
              ? NetworkImage(event['eventImageDtos'][0]['imagePath'] ?? '')
              : const AssetImage('assets/placeholder_image_path')
                  as ImageProvider,
        ),
        title: Text(
          '${event['eventTypeCode'] ?? ''}',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 0),
            Text('${event['eventLocation'] ?? ''}'),
            const SizedBox(
              height: 1,
            ),
            Text('${event['eventDate'] ?? ''}'),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            _navigateToEventDetails(event, context);
          },
          icon: const Icon(Icons.arrow_forward),
        ),
      ),
    );
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

          return _buildEventAvatar(event, imageBytes);
        }
      },
    );
  }

  List<Widget> _buildEventList(List<Map<String, dynamic>> data) {
    return data.map((event) => _buildEventBox(event)).toList();
  }
}
