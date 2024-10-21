import 'package:Shubhvite/Common/appcolors.dart';
import 'package:Shubhvite/Common/double_buttons.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactEditPage extends StatefulWidget {
  final String displayName;
  final String email;
  final String phoneNumber;
  final int index;
  List<Contact> filteredContacts;

  ContactEditPage({
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.index,
    required this.filteredContacts,
  });

  @override
  _ContactEditPageState createState() => _ContactEditPageState();
}

class _ContactEditPageState extends State<ContactEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _searchController = TextEditingController();
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.displayName.isNotEmpty ? widget.displayName : "No name",
    );
    _emailController = TextEditingController(
      text: widget.email.isNotEmpty ? widget.email : "No email address",
    );
    _phoneController = TextEditingController(
      text: widget.phoneNumber.isNotEmpty
          ? widget.phoneNumber
          : "No phone number",
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String query) {
    setState(() {
      widget.filteredContacts = widget.filteredContacts
          .where((contact) =>
              contact.displayName
                  ?.toLowerCase()
                  .contains(query.toLowerCase()) ==
              true)
          .toList();
    });
  }

// Assuming you have a list or a way to check existing emails

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();

      // Check if the email already exists
      if (widget.email.isNotEmpty && email != widget.email) {
        // Show an error dialog or message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('This email already exists. Please use a different one.'),
          ),
        );
      } else if (widget.phoneNumber.isNotEmpty &&
          _phoneController == widget.phoneNumber) {
      } else {
        Navigator.pop(context, {
          'index': widget.index,
          'name': _nameController.text.trim(),
          'email': email,
          'phone': _phoneController.text.trim(),
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Contact',
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
            )),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
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
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder(
                      horizontalInside:
                          BorderSide(color: Colors.grey), // Row lines only
                      top: BorderSide(color: Colors.grey), // Top border
                      bottom: BorderSide(color: Colors.grey), // Bottom border
                      left: BorderSide(
                          color: Colors.grey), // Left border (start column)
                      right: BorderSide(
                          color: Colors.grey), // Right border (end column)
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
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Name'),
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
                      for (int i = 0; i < widget.filteredContacts.length; i++)
                        TableRow(children: [
                          TableCell(
                            child: Center(
                              child: Checkbox(
                                value: false,
                                onChanged: (bool? value) {},
                              ),
                            ),
                          ),
                          TableCell(
                              child: Center(
                                  heightFactor: 2.5, child: Text('${i + 1}'))),
                          TableCell(
                            child: InkWell(
                              onTap: () async {
                                // Handle tap to edit contact
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Text(widget.filteredContacts[i].displayName ??
                                      ''),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Checkbox(
                                value: false,
                                onChanged: (bool? value) {},
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Checkbox(
                                value: false,
                                onChanged: (bool? value) {},
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Checkbox(
                                value: false,
                                onChanged: (bool? value) {},
                              ),
                            ),
                          ),
                        ]),
                    ],
                  ),
                ),
              ),
              Container(
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
                          '   Edit Contact',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                           fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: ' Name',
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
                              return 'Name cannot be empty';
                            } else if (value.length >= 100) {
                              return 'Name allows max 100 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 19),
                        TextFormField(
                          controller: _emailController,
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
                        ),
                        const SizedBox(height: 19),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: false,
                            signed: false,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: 'Enter your phone number',
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
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (!_validatePhoneNumber(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(children: [
                          doubleButton(
                              text: "Update",
                              gradient: LinearGradient(
                                  colors: Appcolors.buttoncolors),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _saveContact();
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
                                Navigator.pop(context);
                              }),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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

  bool _validatePhoneNumber(String value) {
    // Remove spaces and check if the phone number contains 10 to 12 digits
    final RegExp phoneExp = RegExp(r'^\d{10,12}$');
    String cleanedValue = value.replaceAll(' ', '');
    return phoneExp.hasMatch(cleanedValue);
  }
}
