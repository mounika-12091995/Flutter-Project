import 'dart:convert';

import 'package:Shubhvite/global/appcolors.dart';
import 'package:Shubhvite/global/primary_Button.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:Shubhvite/Common/utils.dart';

class updated_mobile extends StatefulWidget {
  @override
  State<updated_mobile> createState() => _updated_mobileState();
}

bool isLoading = false;
Map<String, dynamic> responseData = {};

class _updated_mobileState extends State<updated_mobile> {
  String phoneNumber = '';
  final _formKey = GlobalKey<FormState>();
  String numberWithoutDialCode = '';

  String dialCode = '91';
  // Set default dial code to 91
  String selectedCountry = 'IN';

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> updateMobile() async {
    String? userID = await getData('userId');
    String? authToken = await getData('token');
    setState(() {
      isLoading = true;
    });
    // Show activity indicator

    await Future.delayed(const Duration(seconds: 2));
    // Define the API endpoint
    String apiUrl = "http://13.50.58.181:8085/profile/updatephone";

    // Define the data to be sent in the request body

    // print("")
    Map<String, dynamic> data = {
      "userId": userID,
      "phoneNo": numberWithoutDialCode,
      "countryCode": dialCode,
      "country": selectedCountry,
    };

    // Encode the data to JSON
    String requestBody = jsonEncode(data);

    print("Request body : $requestBody");

    // Make the POST request
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
        body: requestBody,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request successful, handle the response data
        print("Response: ${response.body}");
        //final data = json.decode(response.body);
        Map<String, dynamic> parsedData = jsonDecode(response.body);
        setState(() {
          responseData = parsedData;
        });

        String message = responseData["message"].toString();
        int status = responseData["status"];
        if (status == 200) {
          Map<String, dynamic> data = responseData["data"];

          // saveData('phoneNo:', data["phoneNo"].toString());
          updateMobileNumber(data["phoneNo"].toString());
          print("Phone number is ${data["phoneNo"].toString()}");

          showToast(context, message);
          Navigator.pop(context);
        } else {
          // ignore: use_build_context_synchronously
          String errorMsg = responseData["errorMsg"].toString();
          showToast(context, errorMsg);
        }
      } else {
        print("Response: ${response.body}");
        Map<String, dynamic> parsedData = jsonDecode(response.body);
        // String message = responseData["message"].toString();
        print("Error: ${response.statusCode}");
        String errorMsg = parsedData["errorMsg"].toString();
        // ignore: use_build_context_synchronously
        showToast(context, errorMsg);
      }
    } catch (e) {
      // Request failed due to an exception
      print("Exception: $e");
    } finally {
      // Hide activity indicator after request completes
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateMobileNumber(String newMobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNo', newMobile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Mobile number",
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
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "Please Update the mobile number forcreate event.",
                style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 19, vertical: 0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(
                          255, 71, 71, 71)), // Add border color here
                  borderRadius: BorderRadius.circular(60.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InternationalPhoneNumberInput(
                        initialValue: PhoneNumber(isoCode: selectedCountry),
                        onInputChanged: (PhoneNumber number) {
                          setState(() {
                            phoneNumber = number.phoneNumber!;
                            print('maheshphone$phoneNumber');
                            numberWithoutDialCode =
                                phoneNumber.replaceAll(dialCode, '');
                            numberWithoutDialCode =
                                numberWithoutDialCode.replaceAll('', '');
                            selectedCountry = number.isoCode!;
                            dialCode = number.dialCode!;
                          });
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.DIALOG,
                        ),
                        inputDecoration: InputDecoration(
                          hintText: 'Phone Number',
                          border: InputBorder.none,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: false),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
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
              GradientButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await updateMobile();
                  }
                },
                text: 'Update Mobile number',
                gradient: LinearGradient(
                  colors: Appcolors.buttoncolors,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
