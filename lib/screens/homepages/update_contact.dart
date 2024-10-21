import 'package:Shubhvite/Common/double_buttons.dart';
import 'package:Shubhvite/global/appcolors.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class updateContact extends StatefulWidget {
  final String eventTitle;
  final String eventType;
  final String eventDate;
  final String location;
  final String enteredText;
  final String eventID;
  final String remainderDays;
  final String isEnabled;
  final String selectedDate;
  final List<Contact> filteredContacts;
  const updateContact(
      {super.key,
      required this.eventTitle,
      required this.eventType,
      required this.eventDate,
      required this.location,
      required this.enteredText,
      required this.eventID,
      required this.remainderDays,
      required this.isEnabled,
      required this.selectedDate,
      required this.filteredContacts});

  @override
  State<updateContact> createState() => _updateContact();
}

class _updateContact extends State<updateContact> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Contact> _selectedContacts = [];
  bool isselected = false;

  List<Color> avatarColors = [
    const Color.fromARGB(158, 244, 67, 54),
    const Color.fromARGB(158, 33, 149, 243),
    const Color.fromARGB(162, 76, 175, 79),
    const Color.fromARGB(144, 254, 220, 47),
    const Color.fromARGB(154, 255, 64, 128),
    // Add more colors as needed
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Edit Contact',
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
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: {
                      0: const FixedColumnWidth(30.0),
                      1: const FixedColumnWidth(30.0),
                      2: const FixedColumnWidth(180.0),
                      3: const FixedColumnWidth(50.0),
                      4: const FixedColumnWidth(50.0),
                      // 4: const FixedColumnWidth(50.0),
                    },
                    children: [
                      const TableRow(children: [
                        TableCell(child: Center(child: Text(''))),
                        TableCell(child: Center(child: Text('#'))),
                        TableCell(child: Center(child: Text('Name'))),
                        TableCell(child: Center(child: Icon(Icons.phone))),
                        TableCell(child: Center(child: Icon(Icons.email))),
                        // TableCell(child: Center(child: Icon(Icons.))),
                      ]),
                      for (int i = 0; i < widget.filteredContacts.length; i++)
                        TableRow(children: [
                          TableCell(
                            child: Center(
                              child: Checkbox(
                                value: isselected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isselected = value ?? false;
                                    if (value == true) {
                                      _selectedContacts
                                          .add(widget.filteredContacts[i]);
                                    } else {
                                      _selectedContacts
                                          .remove(widget.filteredContacts[i]);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          TableCell(child: Center(child: Text('${i + 1}'))),
                          TableCell(
                              child: Center(
                                  child: Text(
                                      widget.filteredContacts[i].displayName ??
                                          ''))),
                          TableCell(
                            child: Center(
                              child: IconButton(
                                  icon: const Icon(Icons.message),
                                  onPressed: () {},
                                  color: Color.fromARGB(255, 124, 126, 129)),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: IconButton(
                                  icon: const Icon(Icons.email),
                                  onPressed: () {},
                                  color:
                                      const Color.fromARGB(255, 143, 145, 146)),
                            ),
                          ),
                          // TableCell(
                          //   child: Center(
                          //     child: ClipOval(
                          //       child: widget.filteredContacts[i].avatar != null &&
                          //               widget
                          //                   .filteredContacts[i].avatar!.isNotEmpty
                          //           ? CircleAvatar(
                          //               backgroundImage: MemoryImage(
                          //                   widget.filteredContacts[i].avatar!),
                          //               backgroundColor: Colors.transparent,
                          //               radius: 25.0,
                          //             )
                          //           : Container(
                          //               decoration: BoxDecoration(
                          //                 shape: BoxShape.circle,
                          //                 color:
                          //                     avatarColors[i % avatarColors.length],
                          //                 border: Border.all(
                          //                   color: Colors.black,
                          //                   width: 1.0,
                          //                 ),
                          //               ),
                          //               child: const Icon(Icons.person,
                          //                   color: Colors.white, size: 40.0),
                          //             ),
                          //     ),
                          //   ),
                          // ),
                        ]),
                    ],
                  ),
                ),
              ),
              Container(
                width: 330,
                height: 320,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.elliptical(25, 29))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Contact',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: name,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 13),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ' name cannot be empty';
                        } else if (value.length >= 100) {
                          return ' name allow max 100';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 19),
                    TextFormField(
                      controller: email,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'Email address',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        if (!_validateEmail(value)) {
                          return 'Enter a valid email';
                        }
                        // Add more email validation if needed
                        return null;
                      },
                    ),
                    const SizedBox(height: 19),
                    TextFormField(
                      controller: number,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'Mobile Number',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 13),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter mobile number';
                        } else if (value.length >= 11) {
                          return 'please enter valid mobile number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      doubleButton(
                          text: "Save",
                          gradient:
                              LinearGradient(colors: Appcolors.buttoncolors),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {}
                            return null;
                          }),
                      SizedBox(
                        width: 10,
                      ),
                      doubleButton(
                          text: "Cancle",
                          gradient:
                              LinearGradient(colors: Appcolors.buttoncolors),
                          onPressed: () async {
                            Navigator.pop(context);
                          }),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }
}
