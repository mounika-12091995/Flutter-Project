import 'dart:convert';
import 'dart:io';

import 'package:Shubhvite/global/appcolors.dart';
import 'package:Shubhvite/global/double_buttons.dart';
import 'package:Shubhvite/screens/homepages/contact_lists.dart';
import 'package:flutter/material.dart';

import 'package:Shubhvite/screens/homepages/dropdown_menu.dart';

import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class preview_screen extends StatefulWidget {
  final String eventTitle;
  final String eventType;
  final String eventDate;
  final String location;
  final String enteredText;
  final String eventTransactionId;
  final List<File?> selectedImages;
  List<dynamic> eventVideoDtos;
  final String videoUrl;

  preview_screen({
    Key? key,
    required this.eventTitle,
    required this.eventType,
    required this.eventDate,
    required this.location,
    required this.enteredText,
    required this.eventTransactionId,
    required this.selectedImages,
    required this.eventVideoDtos,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<preview_screen> createState() => _previewState();
}

class _previewState extends State<preview_screen> {
  DateTime selectedDate = DateTime.now();
  DateTime? createeventDate;
  String differenceInDays = '';
  VideoPlayerController? _controller;
  bool isLoading = false;
  String date = "";
  bool _enable = false;
  String isEnabled = "";
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    date = DateFormat('yyyy-MM-ddTHH:mm').format(selectedDate);

    _initializeVideoPlayerFuture = _initVideoPlayer();

    String eventDates = widget.eventDate;
    print("object:$eventDates");
    List<String> dateTimeParts = eventDates.split(' ');
    createeventDate = DateFormat('yyyy-MM-dd').parse(dateTimeParts[0]);
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initVideoPlayer() async {
    try {
      String? authToken = await getData('token');
      final response = await http.get(
        Uri.parse(
            'http://13.50.58.181:8085/media/video-url?key=${widget.videoUrl}'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> parsedData = jsonDecode(response.body);
        String finalVideoURL = parsedData["data"].toString();

        _controller = VideoPlayerController.network(finalVideoURL)
          ..addListener(() {
            if (_controller!.value.hasError) {
              print(
                  'Video player error: ${_controller!.value.errorDescription}');
            }
          });

        await _controller!.initialize();
        _controller!.setLooping(true);
        setState(() {}); // Update UI after initialization
      } else {
        print('Failed to load video: ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading video: $error');
    }
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date = DateFormat('yyyy-MM-ddTHH:mm').format(picked);
      });

      Duration difference = selectedDate.difference(createeventDate!);

      differenceInDays = difference.inDays.toString();
      print("differenceInDays:$differenceInDays");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Invitation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
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
      backgroundColor: Colors.white,
      endDrawer: Dropdown_menu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create a new video invitation which can be shared with your family and friends',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              ),
              Container(
                width: 350.0,
                height: 350.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: _controller != null
                    ? Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          AspectRatio(
                            aspectRatio: 0.9,
                            child: VideoPlayer(_controller!),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _controller!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_controller!.value.isPlaying) {
                                        _controller!.pause();
                                      } else {
                                        _controller!.play();
                                      }
                                    });
                                  },
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: 250,
                                  height: 10,
                                  child: VideoProgressIndicator(
                                    _controller!,
                                    allowScrubbing: true,
                                    colors: VideoProgressColors(
                                      playedColor: Colors.blue,
                                      backgroundColor: Colors.grey,
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Set Reminder',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                  Tooltip(
                    message:
                        'Reminder emails will be sent based on the below date selection',
                    waitDuration: Duration(milliseconds: 500), // Adjust delay
                    showDuration:
                        Duration(seconds: 2), // Increase visibility duration
                    preferBelow: true, // Position the tooltip below
                    decoration: BoxDecoration(
                      color: Colors.grey[700], // Background color
                    ),
                    textStyle: TextStyle(color: Colors.white), // Text color
                    child: Icon(Icons.info_outline, color: Colors.red),
                  ),
                  SizedBox(
                    width: 20,
                  ),

                  // This Stack widget creates the effect of displaying text inside the switch area
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Transform.scale(
                        scaleX: 1.7,
                        scaleY:
                            1.3, // Adjust this value to increase/decrease the size
                        child: Switch(
                          value: _enable,
                          onChanged: (bool val) {
                            setState(() {
                              _enable = val;
                            });
                          },
                          activeColor: Color.fromARGB(255, 7, 162, 13),
                          inactiveThumbColor: Colors.white70,
                        ),
                      ),
                      Positioned(
                        right: 30, // Position the text inside the switch area
                        child: Text(
                          _enable ? 'Yes' : 'No',
                          style: TextStyle(
                            color: _enable
                                ? Color.fromARGB(230, 245, 243, 243)
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                enabled: _enable,
                controller: TextEditingController(
                  text: "${selectedDate.toLocal()}".split(' ')[0],
                ),
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Event Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  doubleButton(
                    onPressed: () async {
                      savenext();
                    },
                    text: 'Next',
                    gradient: LinearGradient(
                      colors: Appcolors.buttoncolors,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void savenext() {
    setState(() {
      isLoading = true; // Show activity indicator
      _controller!.pause();
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => contactList(
          eventTitle: widget.eventTitle,
          eventType: widget.eventType,
          eventDate: widget.eventDate,
          location: widget.location,
          eventID: widget.eventTransactionId,
          enteredText: widget.enteredText,
          remainderDays: differenceInDays,
          isEnabled: isEnabled,
          selectedDate: date,
        ),
      ),
    );
    setState(() {
      isLoading = false; // Show activity indicator
    });
  }
}
