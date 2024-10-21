import 'dart:io';
import 'package:Shubhvite/global/appcolors.dart';
import 'package:Shubhvite/global/primary_Button.dart';
import 'package:Shubhvite/global/secound_primary_button.dart';
import 'package:Shubhvite/model/api_calls.dart';
import 'package:flutter/material.dart';
import 'package:Shubhvite/screens/homepages/dropdown_menu.dart';
import 'package:Shubhvite/screens/homepages/preview_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:Shubhvite/Common/utils.dart';

class EventcreatePages extends StatefulWidget {
  const EventcreatePages({super.key});
  @override
  _EventcreatePage createState() => _EventcreatePage();
}

class _EventcreatePage extends State<EventcreatePages> {
  final List<File?> _selectedImages = List<File?>.filled(6, null);
  Map<String, dynamic> responseData = {};
  Map<String, dynamic> responseEvents = {};
  List<Map<String, dynamic>> arrayEvents = [{}];
  List<String> eventList = [];
  List<dynamic> arrImages = [];
  final GlobalKey<FormState> _validatekey = GlobalKey<FormState>();
  FocusNode _locationFocusNode = FocusNode();

  var jsonResponse = {};
  String videourl = "";
  String? _errorMessage;

  bool isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _txtEventController = TextEditingController();
  TextEditingController _txtLocationController = TextEditingController();
  // String selectedEvent = 'Anniversary'; // Dropdown default value

  final _txtAboutEvent = TextEditingController();
  final _scrollController = ScrollController();
  bool _emojiShowing = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String formattedDateTime = '';
  String displayDateTime = '';
  final FocusNode _focusNode = FocusNode();
  String? selectedEvent;
  bool showTextField = false;
  TextEditingController customEventController = TextEditingController();

  String address = 'Address: ';

  @override
  void dispose() {
    _txtAboutEvent.dispose();
    super.dispose();
  }

  bool isMenuOpen = false;
  bool isuploading = false;

  @override
  void initState() {
    super.initState();
    _getEventstype();
  }

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  Future<void> _handleTokenRefresh(String apiName) async {
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

          // Retry fetching events with the new token
          if (apiName == "EventType") {
            await _getEventstype();
            ();
          } else {
            setState(() {
              selectedEvent = customEventController.text;
            });
            await createEvent();
          }
        } else {
          print("Failed to refresh token: ${response['status']}");
        }
      }
    } catch (error) {
      print("Failed to refresh token: $error");
    }
  }

  Future<void> _choosePhoto(int index) async {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await _imagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  if (pickedFile != null) {
                    _selectedImages[index] = File(pickedFile.path);
                  }
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await _imagePicker.pickImage(source: ImageSource.camera);
                setState(() {
                  if (pickedFile != null) {
                    _selectedImages[index] = File(pickedFile.path);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // getting event type in drop down
  Future<void> _getEventstype() async {
    print("logs print");
    try {
      String? authToken = await getData('token');
      if (authToken != null) {
        Map<String, dynamic> response =
            await apiService.getEventTypes(authToken);

        if (response['status'] == 200) {
          setState(() {
            responseData = response['data'];
            List<dynamic> data = responseData['data'];
            for (var item in data) {
              eventList.add(item['name']);
            }
          });
        } else {
          // String message = responseData["message"].toString();
          print("Error: ${response['statusCode']}");
          String errorMsg = response["error"].toString();

          if (errorMsg == "Invalid token") {
            _handleTokenRefresh("EventType");
          }

          setState(() {});
        }
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> createEvent() async {
    print("API Call start");
    setState(() {
      isLoading = true; // Show activity indicator
    });

    await Future.delayed(Duration(seconds: 2));
    String? userID = await getData('userId');
    if (jsonResponse.length >= 1) {
      arrImages = jsonResponse['data'];
    }
    String? authToken = await getData('token');

    Map<String, dynamic> data = {
      "eventTypeCode": selectedEvent,
      "userId": userID,
      "eventTitle": _txtEventController.text,
      "eventDate": formattedDateTime,
      "eventLocation": _txtLocationController.text,
      "aboutEvent": _txtAboutEvent.text,
      "eventStatus": "Created",
      "eventImageDtos": [
        for (int i = 0; i < arrImages.length; i++) {"imageKey": arrImages[i]}
      ],
      "timestamp": "2024-03-21T05:57:38.709Z",
    };

    try {
      if (authToken != null) {
        Map<String, dynamic> response =
            await apiService.createEvent(data, authToken);

        if (response['status'] == 200) {
          setState(() {
            responseData = response['data'];
          });

          String message = responseData["message"].toString();
          String eventTransactionId = responseData["data"]["id"].toString();
          List<dynamic> eventVideoDtos = responseData["data"]["eventVideoDtos"];
          String videourl =
              eventVideoDtos.isNotEmpty ? eventVideoDtos[0]['videoUrl'] : "";

          if (response['status'] == 200) {
            showToast(context, message);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => preview_screen(
                  eventTitle: _txtEventController.text,
                  eventType: selectedEvent!,
                  eventDate: formattedDateTime,
                  location: _txtLocationController.text,
                  enteredText: _txtAboutEvent.text,
                  eventTransactionId: eventTransactionId,
                  selectedImages: _selectedImages,
                  eventVideoDtos: eventVideoDtos,
                  videoUrl: videourl,
                ),
              ),
            );
          } else {
            print("message $message");

            showToast(context, message);
          }
        } else {
          print("Response: ${response['data']}");
          String errorMsg = response['data']["message"].toString();
          print("message $errorMsg");

          if (errorMsg == "Expired Token") {
            _handleTokenRefresh("CreateEvent");
          }

          showToast(context, errorMsg);
        }
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      setState(() {
        isLoading = false; // Hide activity indicator
      });
    }
  }

  Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> _getImage(int index) async {
    FocusScope.of(context).unfocus();
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImages[index] = File(pickedFile.path);
      }
    });
  }

  Future<void> uploadImage(List<File> images) async {
    setState(() {
      isuploading = true; // Show activity indicator
    });

    try {
      String? authToken = await getData('token');

      if (authToken != null) {
        Map<String, dynamic> response =
            await apiService.uploadImage(images, authToken);

        if (response['status'] == 200) {
          jsonResponse = response['data'];

          String message = jsonResponse["message"].toString();
          showToast(context, message);
        } else {
          print("Failed to upload image: ${response['status']}");
          print("Response body: ${response['data']}");
        }
      }
    } catch (e) {
      print("Error occurred while uploading image: $e");
    } finally {
      setState(() {
        isuploading = false; // Hide activity indicator
      });
    }
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> _selectDateTime(BuildContext context) async {
    // Select Date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Select Time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine Date and Time
        DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        // Check if the selected date and time are not in the past
        if (selectedDateTime.isBefore(now) &&
            pickedDate.isAtSameMomentAs(today)) {
          // Show an error message if the selected time is in the past
          showToast(context, "Please select a future time");
          return;
        }

        setState(() {
          selectedDate = pickedDate;
          selectedTime = pickedTime;
          FocusScope.of(context).requestFocus(_locationFocusNode);
        });

        formattedDateTime =
            DateFormat('yyyy-MM-ddTHH:mm').format(selectedDateTime);
        displayDateTime =
            DateFormat('dd-MMMM-yyyy, h:mm a').format(selectedDateTime);

        print('Selected DateTime: $formattedDateTime');
      }
    } else {
      // If no date is selected, use the current date and time
      DateTime now = DateTime.now();
      setState(() {
        selectedDate = now;
        selectedTime = TimeOfDay.fromDateTime(now);
      });

      formattedDateTime = DateFormat('yyyy-MM-ddTHH:mm').format(now);

      print('Selected DateTime: $formattedDateTime');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Event',
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

        // Set your desired background color
      ),
      endDrawer: Dropdown_menu(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _validatekey,
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'You can create your own invitation video for your event if you want to',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'calibri',
                     
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 17.0),
                      TextFormField(
                        controller: _txtEventController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        
                        decoration: InputDecoration(
                          hintText: 'Event Title',
                         
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            
                          ),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                         maxLength: 256,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Event Title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 17.0),
                      DropdownButtonFormField<String>(
                        value: selectedEvent,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'Event Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedEvent = newValue!;
                            showTextField = (selectedEvent == 'Others');
                          });
                        },
                        items: eventList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal),
                            ),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an event type';
                          }
                          return null; // Return null if there is no error
                        },
                      ),
                      if (showTextField)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: customEventController,
                              decoration: InputDecoration(
                                hintText: 'Enter event',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Event type';
                                }
                                return null;
                              }),
                        ),
                      const SizedBox(height: 9.0),
                      TextFormField(
                        controller: TextEditingController(
                          text: "$displayDateTime",
                        ),
                        readOnly: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'Event Date',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDateTime(context),
                          ),
                        ),
                        onTap: () => _selectDateTime(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select Event Date & Time';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 9.0),
                      TextFormField(
                        controller: _txtLocationController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                         maxLength: 256,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Location";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                      TextFormField(
                        controller: _txtAboutEvent,
                        focusNode: _focusNode,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.done,
                        maxLength: 1000,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: '\nMessage',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                            left: 16.0,
                            bottom: 8.0,
                            top: 8.0,
                            right: 16.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter about event';
                          }
                          return null;
                        },
                      ),
                      Offstage(
                        offstage: !_emojiShowing,
                        child: EmojiPicker(
                          textEditingController: _txtAboutEvent,
                          scrollController: _scrollController,
                          config: const Config(
                            height: 256,
                            // Other configurations
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "  Upload images ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('(max-6)')
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                            6,
                            (index) => GestureDetector(
                              onTap: () {
                                if (_selectedImages[index] != null) {
                                  _viewImage(_selectedImages[index]!, index);
                                } else {
                                  _choosePhoto(index);
                                }
                              },
                              child: SizedBox(
                                width: 110,
                                height: 110,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Center(
                                    child: _selectedImages[index] != null
                                        ? Image.file(_selectedImages[index]!)
                                        : Icon(Icons.photo),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_errorMessage != null) ...[
                        SizedBox(height: 20),
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ],
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

                          int selectedCount = _selectedImages
                              .where((image) => image != null)
                              .length;

                          setState(() {
                            if (selectedCount < 1) {
                              _errorMessage =
                                  'Please select at least one image.';
                            } else {
                              _errorMessage = null;
                            }
                          });

                          if (selectedCount >= 1) {
                            List<File> images = _selectedImages
                                .where((image) => image != null)
                                .cast<File>()
                                .toList();
                            await uploadImage(images);
                          }
                        },
                        child: isuploading
                            ? SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Upload Pictures',
                                    style: TextStyle(
                                        color: Color.fromARGB(173, 0, 0, 0)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.upload_file,
                                      color: Color.fromARGB(173, 0, 0, 0))
                                ],
                              ),
                      ),
                      const SizedBox(height: 20.0),
                      GradientButton(
                        onPressed: () async {
                          int selectedCount = _selectedImages
                              .where((image) => image != null)
                              .length;

                          setState(() {
                            if (selectedCount < 1) {
                              _errorMessage =
                                  'Please select at least one image.';
                            } else {
                              _errorMessage = null;
                            }
                          });

                          if (_validatekey.currentState!.validate()) {
                            await createEvent();
                          }
                        },
                        text: 'Preview',
                        gradient: LinearGradient(
                          colors: Appcolors.buttoncolors,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEmojiPicker() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _showKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).requestFocus(_txtEventController as FocusNode?);
    });
  }

  void _viewImage(File? image, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (image != null) ...[
                  Container(
                    child: Image.file(image),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _removeImage(index);
                          Navigator.pop(context);
                        },
                        child: const Text('Remove'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          _replaceImage(index);
                          Navigator.pop(context);
                        },
                        child: const Text('Replace'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages[index] = null;
    });
  }

  Future<void> _replaceImage(int index) async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImages[index] = File(pickedFile.path);
      });
    }
  }
}
