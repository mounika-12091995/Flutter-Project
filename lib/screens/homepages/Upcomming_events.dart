import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:Shubhvite/global/appcolors.dart';
import 'package:Shubhvite/global/double_buttons.dart';
import 'package:Shubhvite/global/removeaction_button.dart';
import 'package:Shubhvite/model/api_calls.dart';
import 'package:Shubhvite/screens/homepages/reschedule.dart';
import 'package:Shubhvite/screens/homepages/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:Shubhvite/screens/homepages/dropdown_menu.dart'; // Import for the custom dropdown widget
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:Shubhvite/Common/utils.dart';

class EventDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> event;
  String isEnable;
  final Uint8List imagebye;

  EventDetailsScreen(
      {Key? key,
      required this.event,
      required this.imagebye,
      required this.isEnable})
      : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isLoading = true;
  Map<String, dynamic> responseData = {};

  List<Map<String, String>> eventGroups = [];

  @override
  void initState() {
    super.initState();
    fetchEventDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upcoming event',
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
      endDrawer: Dropdown_menu(), // Drawer widget for the end side
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 32, 31, 31)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: widget.event['customHeight'] ?? 200.0,
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
                        child: widget.imagebye.isNotEmpty
                            ? Image.memory(
                                widget.imagebye,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: widget.event['customHeight'] ?? 200.0,
                              )
                            : Image.asset(
                                'assets/splash1.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: widget.event['customHeight'] ?? 200.0,
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
                              SizedBox(
                                width: 250,
                                child: Text(
                                  '${widget.event['eventTitle']}',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 12,
                                      color: Color.fromARGB(255, 37, 38, 39)),
                                  const SizedBox(width: 15),
                                  Text(
                                      '${widget.event['eventLocation'] ?? 'Not specified'}'),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month,
                                      size: 18,
                                      color: Color.fromARGB(255, 59, 60, 61)),
                                  const SizedBox(width: 15),
                                  Text(
                                      '${widget.event['eventDate'] ?? 'Not specified'}'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 10.0),
                  removeaction(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RescheduleScreen(
                            event: widget.event,
                          ),
                        ),
                      );
                    },
                    text: 'Reschedule',
                    gradient: LinearGradient(
                      colors: Appcolors.buttoncolors,
                    ),
                  ),
                  const SizedBox(width: 27.0),
                  doubleButton(
                    onPressed: () async {
                      await removeEvent();
                    },
                    text: 'Cancel',
                    gradient: LinearGradient(
                      colors: Appcolors.buttoncolors,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Text('     ${widget.event['aboutEvent'] ?? 'Not specified'}'),
              SizedBox(
                height: 25,
              ),
              Text(
                "   Who responded                                                     ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.start,
              ),
              eventGroups.isEmpty
                  ? Center(
                      heightFactor: 12,
                      child: Text(
                        "No contacts are invite",
                        style: TextStyle(fontSize: 17),
                        textAlign: TextAlign.end,
                      ),
                    )
                  : Table(
                      border: TableBorder(
                        top: BorderSide(
                            color: Colors.grey), // Outer border - top
                        bottom: BorderSide(
                            color: Colors.grey), // Outer border - bottom
                        left: BorderSide(
                            color: Colors.grey), // Outer border - left
                        right: BorderSide(
                            color: Colors.grey), // Outer border - right
                        horizontalInside: BorderSide(
                            color:
                                Colors.grey), // Horizontal lines between rows
                        // No verticalInside to remove column lines
                      ),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(30), // Index column
                        1: FlexColumnWidth(), // Contact name
                        2: FixedColumnWidth(50), // Yes column
                        3: FixedColumnWidth(50),
                        4: FixedColumnWidth(50), // No column
                      },
                      children: [
                        // Table header row
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '#',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Contact List',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Yes',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'No',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'May be',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        // Populate rows with event data
                        for (int i = 0; i < eventGroups.length; i++)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${i + 1}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    eventGroups[i]['contactName'] ?? 'N/A'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: eventGroups[i]['invitationStatus'] ==
                                        'Accepted'
                                    ? Icon(Icons.check_circle_outline,
                                        color: Colors.green)
                                    : SizedBox.shrink(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: eventGroups[i]['invitationStatus'] ==
                                        'Declined'
                                    ? Icon(Icons.cancel_outlined,
                                        color: Colors.red)
                                    : SizedBox.shrink(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(''),
                              )
                            ],
                          )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Icon getYesIcon() {
    return Icon(Icons.check_circle, color: Colors.green);
  }

  Icon getWrongIcon() {
    return Icon(Icons.cancel, color: Colors.red);
  }

  DataRow createDataRow(Map<String, String> invite) {
    return DataRow(cells: [
      DataCell(Text(invite['contactName'] ?? '')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          invite['invitationStatus'] == "Yes" ? getYesIcon() : SizedBox(),
        ],
      )),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          invite['invitationStatus'] == "No" ? getWrongIcon() : SizedBox(),
        ],
      )),
    ]);
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> CancleEvent() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? userID = await getData('userId');
      String? authToken = await getData('token');

      if (userID != null && authToken != null) {
        var response = await apiService.CancleEvent(
          userID,
          widget.event['id'],
          widget.event['eventDate'],
          authToken,
        );

        if (response['status'] == 200) {
          showToast(context, "Event is cancelled successfully");

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => GlobalTabScreen()),
            (route) => false,
          );
        } else {
          showToast(context, response['message'].toString());
        }
      }
    } catch (e) {
      showToast(context, "Error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> removeEvent() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 10),
              const Text(
                'Alert!',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 100),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.black38,
                  ))
            ],
          ),
          content: const Text(
            'Are you sure you want to cancel this event? Once canceled, all associated information will be deleted, and attendees will be notified. This action cannot be undone.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actionsAlignment:
              MainAxisAlignment.center, // Center-align the buttons
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await CancleEvent();
              },
              style: TextButton.styleFrom(
                side: BorderSide(
                    color: Colors.red, width: 2), // Border color and width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchEventDetails() async {
    String? authToken = await getData('token');
    var uri = Uri.parse(
        'http://13.50.58.181:8085/event/getEventDetails?eventId= ${widget.event['id']}');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['data'] != null && jsonData['data']['event'] != null) {
          final eventDetails = jsonData['data']['event'];

          // Extract event invites
          final eventInvites = eventDetails['eventInvites'] ?? [];

          // Prepare a new list to store the converted data
          List<Map<String, String>> updatedEventGroups = [];
          print('eventInvites$eventInvites');

          // Convert dynamic list to the required format
          for (var invite in eventInvites) {
            updatedEventGroups.add({
              'contactName': invite['contactName'].toString(),
              'phoneNo': invite['phoneNo'].toString(),
              'invitationStatus': invite['invitationStatus'] != null
                  ? invite['invitationStatus'].toString()
                  : 'No Response',
            });
          }

          // Update eventGroups with the converted data
          setState(() {
            eventGroups = updatedEventGroups;
          });
        } else {
          throw Exception('Missing or invalid event data in API response');
        }
      } else if (response.statusCode == 204) {
        setState(() {
          eventGroups = []; // Handle case where no data is returned
        });
      } else {
        throw Exception('Failed to load event details: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions or errors
      print('Error fetching event details: $e');
      // Optionally, show a dialog or snackbar to notify the user of the error
    }
  }
}

class ContactDataSource extends DataTableSource {
  final List<Map<String, String>> eventGroups;
  final Icon Function() getYesIcon;
  final Icon Function() getWrongIcon;

  ContactDataSource(this.eventGroups, this.getYesIcon, this.getWrongIcon);

  @override
  DataRow getRow(int index) {
    final invite = eventGroups[index];
    return DataRow(cells: [
      DataCell(Text(invite['contactName'] ?? '')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          invite['invitationStatus'] == "Yes" ? getYesIcon() : SizedBox(),
        ],
      )),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          invite['invitationStatus'] == "No" ? getWrongIcon() : SizedBox(),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => eventGroups.length;

  @override
  int get selectedRowCount => 0;
}
