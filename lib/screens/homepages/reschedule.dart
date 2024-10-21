import 'package:Shubhvite/global/appcolors.dart';
import 'package:Shubhvite/global/secound_primary_button.dart';
import 'package:Shubhvite/model/api_calls.dart';
import 'package:Shubhvite/screens/homepages/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:Shubhvite/screens/homepages/dropdown_menu.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Shubhvite/Common/utils.dart';

class RescheduleScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  const RescheduleScreen({super.key, required this.event});

  @override
  _RescheduleScreenState createState() => _RescheduleScreenState();
}

class _RescheduleScreenState extends State<RescheduleScreen> {
  late TextEditingController firstNameController;
  TextEditingController locationController = TextEditingController();
  late TextEditingController textController;
  late TextEditingController selectedEvent;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  String formattedDateTime = '';
  final _scrollController = ScrollController();
  bool isLoading = false;
  bool _emojiShowing = false;
  String id = '';

  String address = 'Address: ';

  @override
  void dispose() {
    firstNameController.dispose();
    locationController.dispose();
    textController.dispose();
    super.dispose();
  }

  bool isMenuOpen = false;

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
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
        });

        formattedDateTime =
            DateFormat('dd-MMM-yyyy, HH:mm a').format(selectedDateTime);

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

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> updateEvent() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? userID = await getData('userId');
      String? authToken = await getData('token');

      // 21-Aug-2024, 11:10 PM"
      //2024-08-31 15:45
      String updatedDateTime = formattedDateTime.replaceAll('T', ' ');

      if (userID != null && authToken != null) {
        var response = await apiService.updateEvent(
          userID,
          widget.event['id'],
          updatedDateTime,
          locationController.text,
          "RESCHEDULED",
          authToken,
        );

        String message = response["message"].toString();
        showToast(context, message);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => GlobalTabScreen()),
          (route) => false,
        );
      }
    } catch (error) {
      showToast(context, "Error: $error");
      print('Error updating event: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    firstNameController =
        TextEditingController(text: widget.event['eventTitle']);
    locationController =
        TextEditingController(text: widget.event['eventLocation']);
    textController = TextEditingController(text: widget.event['aboutEvent']);
    selectedEvent = TextEditingController(text: widget.event['eventTypeCode']);
    //String id = widget.event['id'];

    formattedDateTime = widget.event['eventDate'];
    List<String> dateTimeParts = formattedDateTime.split(' ');

    try {
      selectedDate = DateFormat('MM-dd-yyyy').parse(dateTimeParts[0]);
      selectedTime =
          TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(dateTimeParts[1]));
    } catch (e) {
      print('Date format error: $e');
      selectedDate = DateTime.now();
      selectedTime = TimeOfDay.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reschedule event',
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
      backgroundColor: Colors.white,
      endDrawer: Dropdown_menu(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: firstNameController,
                      enabled: isLoading,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Event Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 9.0),
                    TextField(
                      controller: selectedEvent,
                      enabled: isLoading,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Event Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 9.0),
                    TextFormField(
                      controller: TextEditingController(
                        text: formattedDateTime,
                      ),
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Event Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDateTime(context),
                        ),
                      ),
                      onTap: () => _selectDateTime(context),
                    ),
                    const SizedBox(height: 9.0),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: 'Location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    TextField(
                      controller: textController,
                      enabled: isLoading,
                      readOnly: true,
                      maxLength: 1000,
                      maxLines: 3,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            _emojiShowing
                                ? Icons.keyboard
                                : Icons.emoji_emotions,
                            color: const Color.fromARGB(255, 31, 30, 30),
                          ),
                        ),
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
                    ),
                    Offstage(
                      offstage: !_emojiShowing,
                      child: EmojiPicker(
                        textEditingController: textController,
                        scrollController: _scrollController,
                        config: const Config(
                          height: 256,
                          // Other configurations
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    secoundButton(
                      onPressed: () async {
                        await updateEvent();
                      },
                      text: 'Send',
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
    );
  }
}
