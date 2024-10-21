import 'package:Shubhvite/global/appcolors.dart';
import 'package:Shubhvite/global/primary_Button.dart';
import 'package:Shubhvite/model/api_calls.dart';
import 'package:Shubhvite/screens/authenticationpage/resetpassword.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Shubhvite/Common/utils.dart'; // Import the utility file

class forgotpassword extends StatefulWidget {
  const forgotpassword({super.key});

  @override
  State<forgotpassword> createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgotpassword> {
  TextEditingController _EmailPhonenumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  //List<Registerresponse> responseData = []; // List to store parsed response data
  Map<String, dynamic> responseData = {}; // Map to store parsed response

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false; // No internet connection
    } else {
      return true; // Internet connection available
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password',
            style: TextStyle(
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
        leading: IconButton(
          icon: Image.asset(
            'assets/arrow-left.png',
            width: 20, // Set desired width
            height: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                const Text(
                  'Enter your email ,or mobile number associated with your account to change your password.',
                  style: TextStyle(
                      color: Color.fromARGB(255, 26, 26, 26),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _EmailPhonenumber,
                      decoration: InputDecoration(
                        hintText: 'Mobile/ Email ',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 13),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email or phone number';
                        }
                        if (!_validateEmail(value) &&
                            !_validatePhoneNumber(value)) {
                          return 'Please enter a valid email or phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 37,
                    ),
                    GradientButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool isConnected = await checkInternetConnectivity();
                          if (isConnected) {
                            await forgotPassword();
                            ();
                            // Internet connection is available
                          } else {
                            showToast(context,
                                'Please check your internet connection');
                          }
                        }
                      },
                      text: "Next",
                      gradient: LinearGradient(
                        colors: Appcolors.buttoncolors,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> forgotPassword() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));

    try {
      Map<String, dynamic> response = await apiService.forgotPassword(
        _EmailPhonenumber.text.toString(),
        false, // Assuming "false" means email, change as per your logic
      );

      if (response['status'] == 200) {
        setState(() {
          responseData = response;
        });

        String message = responseData["message"].toString();
        Map<String, dynamic> data = responseData["data"];

        saveData('userId', data["userId"].toString());

        showToast(context, message);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    resetpassword(mobilenumber: _EmailPhonenumber.text)));
      } else {
        showToast(context, response['errorMsg']);
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  bool _validateEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  bool _validatePhoneNumber(String value) {
    final phoneRegex = RegExp(r'^[\+]+[0-9]{10,13}$');
    return phoneRegex.hasMatch(value);
  }
}
