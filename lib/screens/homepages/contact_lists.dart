import 'dart:io';

import 'package:Shubhvite/Common/double_buttons.dart';
import 'package:Shubhvite/Common/utils.dart';
import 'package:Shubhvite/global/appcolors.dart';
import 'package:Shubhvite/screens/homepages/Invite_pepole.dart';
import 'package:Shubhvite/screens/homepages/addnewcontact.dart';
import 'package:Shubhvite/screens/homepages/editedpahe.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:permission_handler/permission_handler.dart';

class contactList extends StatefulWidget {
  final String eventTitle;
  final String eventType;
  final String eventDate;
  final String location;
  final String enteredText;
  final String eventID;
  final String remainderDays;
  final String isEnabled;
  final String selectedDate;
  const contactList(
      {super.key,
      required this.eventTitle,
      required this.eventType,
      required this.eventDate,
      required this.location,
      required this.enteredText,
      required this.eventID,
      required this.remainderDays,
      required this.isEnabled,
      required this.selectedDate});

  @override
  State<contactList> createState() => _contactListState();
}

class _contactListState extends State<contactList> {
  bool _isLoadingContacts = false;
  bool _showNewContactForm = false;

  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  TextEditingController _searchController = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController number = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isselected = false;

  List<Color> avatarColors = [
    const Color.fromARGB(158, 244, 67, 54),
    const Color.fromARGB(158, 33, 149, 243),
    const Color.fromARGB(162, 76, 175, 79),
    const Color.fromARGB(144, 254, 220, 47),
    const Color.fromARGB(154, 255, 64, 128),
    // Add more colors as needed
  ];
  List<Contact> _selectedContacts = [];
  String? phoneNumber;
  String dialCode = '91';
  // Set default dial code to 91
  String numberWithoutDialCode = '';
  String selectedCountry = 'IN';

  List<Contact> _emailContacts = [];
  List<Contact> _whatsappContacts = [];
  List<Contact> _massageContacts = [];

  @override
  void initState() {
    super.initState();

    requestContactsPermission();
  }

  bool _isAscending = true;

  void _sortContacts() {
    setState(() {
      _filteredContacts.sort((a, b) {
        if (_isAscending) {
          return (a.displayName ?? '').compareTo(b.displayName ?? '');
        } else {
          return (b.displayName ?? '').compareTo(a.displayName ?? '');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact list',
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
      backgroundColor: Colors.white,
      body: _isLoadingContacts
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchTextChanged,
                      decoration: InputDecoration(
                        hintText: 'Search contact from list',
                        filled: true, // Set to true to enable background color
                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 15),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Choose invitation option',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_selectedContacts.isNotEmpty) {
                            setState(() {
                              _filteredContacts.removeWhere((contact) {
                                bool isSelected =
                                    _selectedContacts.contains(contact);
                                if (isSelected) {
                                  _selectedContacts.remove(contact);
                                }
                                return isSelected;
                              });
                            });
                          } else {
                            showToast(context,
                                "Please select at least one contact to delete");
                          }
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Table(
                        border: TableBorder(
                          horizontalInside:
                              BorderSide(color: Colors.grey), // Only row lines
                          top: BorderSide(color: Colors.grey), // Top border
                          bottom:
                              BorderSide(color: Colors.grey), // Bottom border
                          left: BorderSide(
                              color: Colors.grey), // Left column border
                          right: BorderSide(
                              color: Colors.grey), // Right column border
                        ),
                        columnWidths: {
                          0: const FixedColumnWidth(30.0),
                          1: const FixedColumnWidth(30.0),
                          2: const FixedColumnWidth(180.0),
                          3: const FixedColumnWidth(30.0),
                          4: const FixedColumnWidth(30.0),
                          5: const FixedColumnWidth(30.0),
                        },
                        children: [
                          TableRow(children: [
                            TableCell(child: Center(child: Text(''))),
                            TableCell(child: Center(child: Text('#'))),
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
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Image.asset(
                                  'assets/email.png',
                                  fit: BoxFit.cover,
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Image.asset(
                                  'assets/massage.png',
                                  fit: BoxFit.cover,
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ]),
                          for (int i = 0; i < _filteredContacts.length; i++)
                            TableRow(children: [
                              TableCell(
                                child: Center(
                                  child: Checkbox(
                                    value: _selectedContacts
                                        .contains(_filteredContacts[i]),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedContacts
                                              .add(_filteredContacts[i]);
                                        } else {
                                          _selectedContacts
                                              .remove(_filteredContacts[i]);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              TableCell(
                                  child: Center(
                                      heightFactor: 2.5,
                                      child: Text('${i + 1}'))),
                              TableCell(
                                child: InkWell(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ContactEditPage(
                                          displayName: _filteredContacts[i]
                                                  .displayName ??
                                              '',
                                          filteredContacts: _filteredContacts,
                                          email: getPrimaryEmail(
                                                  _filteredContacts[i]) ??
                                              'No email address',
                                          phoneNumber: getPrimaryPhoneNumber(
                                                  _filteredContacts[i]) ??
                                              'No phone number',
                                          index: i,
                                        ),
                                      ),
                                    );

                                    if (result != null) {
                                      setState(() {
                                        _filteredContacts[result['index']]
                                                .displayName =
                                            result['displayName'];
                                        _filteredContacts[result['index']]
                                            .emails
                                            ?.first
                                            .value = result['email'];
                                        _filteredContacts[result['index']]
                                            .phones
                                            ?.first
                                            .value = result['phoneNumber'];
                                      });
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 14,
                                      ),
                                      Text(
                                        _filteredContacts[i].displayName ?? '',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Checkbox(
                                    value: _whatsappContacts
                                        .contains(_filteredContacts[i]),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          _toggleWhatsappContactSelection(
                                              _filteredContacts[i]);
                                        } else {
                                          _whatsappContacts
                                              .remove(_filteredContacts[i]);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Checkbox(
                                    value: _emailContacts
                                        .contains(_filteredContacts[i]),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          _toggleEmailContactSelection(
                                              _filteredContacts[i]);
                                        } else {
                                          _emailContacts
                                              .remove(_filteredContacts[i]);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Checkbox(
                                    value: _massageContacts
                                        .contains(_filteredContacts[i]),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          _toggleMessageContactSelection(
                                              _filteredContacts[i]);
                                        } else {
                                          _massageContacts
                                              .remove(_filteredContacts[i]);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ]),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _showNewContactForm
                      ? Container(
                          width: 330,
                          height: 290,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(25, 29),
                            ),
                          ),
                         
                         
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '   Add new Contact',
                                    style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: name,
                                    keyboardType: TextInputType.name,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      hintText: ' Name',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 13),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Name cannot be empty';
                                      } else if (value.length >= 100) {
                                        return 'Name allows max 100 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 19),
                                  TextFormField(
                                    controller: email,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      hintText: 'Email address',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 19),
                                  Container(
                                    height: 60,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 19, vertical: 0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(255, 71,
                                              71, 71)), // Add border color here
                                      borderRadius: BorderRadius.circular(60.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: InternationalPhoneNumberInput(
                                            initialValue: PhoneNumber(
                                                isoCode: selectedCountry),
                                            onInputChanged:
                                                (PhoneNumber number) {
                                              setState(() {
                                                phoneNumber =
                                                    number.phoneNumber!;
                                                print(
                                                    'maheshphone$phoneNumber');
                                                numberWithoutDialCode =
                                                    phoneNumber!.replaceAll(
                                                        dialCode, '');
                                                numberWithoutDialCode =
                                                    numberWithoutDialCode
                                                        .replaceAll('', '');
                                                selectedCountry =
                                                    number.isoCode!;
                                                dialCode = number.dialCode!;
                                              });
                                            },
                                            selectorConfig: SelectorConfig(
                                              selectorType:
                                                  PhoneInputSelectorType.DIALOG,
                                            ),
                                            inputDecoration: InputDecoration(
                                              hintText: 'Phone Number',
                                              border: InputBorder.none,
                                            ),
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                signed: true, decimal: false),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a valid phone number';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(children: [
                                    doubleButton(
                                        text: "Save",
                                        gradient: LinearGradient(
                                            colors: Appcolors.buttoncolors),
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _addContact();
                                          }
                                        }),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    doubleButton(
                                        text: "Cancel",
                                        gradient: LinearGradient(
                                            colors: Appcolors.buttoncolors),
                                        onPressed: () async {
                                          setState(() {
                                            _showNewContactForm = false;
                                          });
                                        }),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 330,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(25, 29))),
                          child: Row(children: [
                            doubleButton(
                                text: "Add Contact",
                                gradient: LinearGradient(
                                    colors: Appcolors.buttoncolors),
                                onPressed: () async {
                                  setState(() {
                                    _showNewContactForm = true;
                                  });
                                }),
                            SizedBox(
                              width: 25,
                            ),
                            doubleButton(
                                text: "preview",
                                gradient: LinearGradient(
                                    colors: Appcolors.buttoncolors),
                                onPressed: () async {
                                  int lenth = _filteredContacts.length;

                                  if (_selectedContacts.length >= 1) {
                                    print("object${widget.eventTitle}");
                                    print("object${widget.eventType}");
                                    print("object${widget.eventDate}");
                                    print("object${widget.location}");
                                    print("object${widget.eventID}");
                                    print("object${widget.enteredText}");
                                    print("object${widget.isEnabled}");
                                    print("object${widget.selectedDate}");

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Invit_pepole(
                                          eventTitle: widget.eventTitle,
                                          eventType: widget.eventType,
                                          eventDate: widget.eventDate,
                                          location: widget.location,
                                          eventID: widget.eventID,
                                          enteredText: widget.enteredText,
                                          remainderDays: widget.remainderDays,
                                          isEnabled: widget.isEnabled,
                                          selectedDate: widget.selectedDate,
                                          massage: _massageContacts,
                                          selectedContacts: _selectedContacts,
                                          email: _emailContacts,
                                          whatsapp: _whatsappContacts,
                                          lenth: _contacts.length,
                                        ),
                                      ),
                                    );
                                  } else {
                                    showToast(context,
                                        "Please select at least one contact to preview");
                                  }
                                }),
                          ]),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
    );
  }

  String? getPrimaryEmail(Contact contact) {
    return contact.emails != null && contact.emails!.isNotEmpty
        ? contact.emails!.first.value
        : '';
  }

  String? getPrimaryPhoneNumber(Contact contact) {
    return contact.phones != null && contact.phones!.isNotEmpty
        ? contact.phones!.first.value
        : '';
  }

  bool _validateEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  void _addContact() {
    if (_formKey.currentState!.validate()) {
      final newContact = Contact(
        givenName: name.text,
        emails: [Item(label: 'work', value: email.text)],
        phones: [Item(label: 'mobile', value: phoneNumber)],
      );

      ContactsService.addContact(newContact);

      setState(() {
        _contacts.add(newContact);
        showToast(context, "Contacts are added successfully");
        _fetchContacts();
        _showNewContactForm = false;
        name.clear();
        email.clear();
        number.clear();
      });
    }
  }

  void _onSearchTextChanged(String query) {
    setState(() {
      _filteredContacts = _contacts
          .where((contact) =>
              contact.displayName
                  ?.toLowerCase()
                  .contains(query.toLowerCase()) ==
              true)
          .toList();
    });
  }

  Future<void> requestContactsPermission() async {
    final PermissionStatus permissionStatus =
        await Permission.contacts.request();

    if (Platform.isIOS) {
      // iOS-specific code
      _getContacts();
    } else if (Platform.isAndroid) {
      if (permissionStatus.isGranted) {
        // Permission is granted, proceed with accessing contacts
        _getContacts();
      } else {
        // Permission denied, handle it accordingly
        setState(() {
          _isLoadingContacts = false;
        });
      }
    }
  }

  Future<void> _getContacts() async {
    setState(() {
      _isLoadingContacts = true;
    });

    if (Platform.isIOS) {
      // On iOS, fetch contacts directly
      _fetchContacts();
    } else if (Platform.isAndroid) {
      if (await Permission.contacts.isGranted) {
        // On Android, fetch contacts if permission is granted
        _fetchContacts();
      } else {
        print('Permission denied');
        setState(() {
          _isLoadingContacts = false;
        });
      }
    }
  }

  void _toggleMessageContactSelection(Contact contact) {
    setState(() {
      if (_massageContacts.contains(contact)) {
        _massageContacts.remove(contact);
      } else {
        if (_emailContacts.contains(contact) ||
            _whatsappContacts.contains(contact)) {
          _emailContacts.remove(contact);
          _whatsappContacts.remove(contact);
        }
        _massageContacts.add(contact);
      }
    });
    print('Message: ${_massageContacts.contains(contact)}');
  }

  void _toggleEmailContactSelection(Contact contact) {
    setState(() {
      if (_emailContacts.contains(contact)) {
        _emailContacts.remove(contact);
      } else {
        if (_massageContacts.contains(contact) ||
            _whatsappContacts.contains(contact)) {
          _massageContacts.remove(contact);
          _whatsappContacts.remove(contact);
        }
        _emailContacts.add(contact);
      }
    });
    print('Email: ${_emailContacts.contains(contact)}');
  }

  void _toggleWhatsappContactSelection(Contact contact) {
    setState(() {
      if (_whatsappContacts.contains(contact)) {
        _whatsappContacts.remove(contact);
      } else {
        if (_massageContacts.contains(contact) ||
            _emailContacts.contains(contact)) {
          _massageContacts.remove(contact);
          _emailContacts.remove(contact);
        }
        _whatsappContacts.add(contact);
      }
    });
    print('Email: ${_whatsappContacts.contains(contact)}');
  }

  Future<void> _fetchContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();

    // Filter contacts that have a phone number
    List<Contact> contactsWithPhoneNumber = contacts
        .where(
            (contact) => contact.phones != null && contact.phones!.isNotEmpty)
        .toList();

    setState(() {
      _contacts = contactsWithPhoneNumber;
      print("Contacts List : $_contacts");

      _filteredContacts = _contacts;

      print("_filteredContacts List : $_filteredContacts");
      _isLoadingContacts = false;
    });
  }
}
