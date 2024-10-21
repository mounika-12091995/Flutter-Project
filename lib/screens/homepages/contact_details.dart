import 'package:Shubhvite/global/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactDetailsPage extends StatelessWidget {
  final Contact contact;
  final onContactDeviceSave;

  ContactDetailsPage({required this.contact, this.onContactDeviceSave});

  Future<void> _openExistingContactOnDevice(BuildContext context) async {
    try {
      final updatedContact = await ContactsService.openExistingContact(
        contact,
        iOSLocalizedLabels:
            false, // assuming iOSLocalizedLabels is a global variable
      );
      if (onContactDeviceSave != null) {
        onContactDeviceSave(updatedContact ?? contact);
      }
      Navigator.of(context).pop();
    } on FormOperationException catch (e) {
      switch (e.errorCode) {
        case FormOperationErrorCode.FORM_OPERATION_CANCELED:
          print('Form operation canceled.');
          break;
        case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
          print('Form could not be opened.');
          break;
        case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
        default:
          print('Unknown form operation error: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _openExistingContactOnDevice(context),
          ),
        ],
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
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: TextEditingController(
                  text: "Name:  ${contact.displayName}",
                ),
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: TextEditingController(
                  text:
                      'Email:  ${contact.emails?.isNotEmpty == true ? contact.emails!.first.value : "No email address"}',
                ),
                readOnly: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: TextEditingController(
                  text:
                      'Phone:  ${contact.phones?.isNotEmpty == true ? contact.phones!.first.value : "No phone number"}',
                ),
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
