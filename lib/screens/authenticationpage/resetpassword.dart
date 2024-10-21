import 'dart:async';
import 'package:Shubhvite/global/appcolors.dart';
import 'package:Shubhvite/global/primary_Button.dart';
import 'package:Shubhvite/model/api_calls.dart';
import 'package:Shubhvite/screens/authenticationpage/loginpage.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class resetpassword extends StatefulWidget {
  final String mobilenumber;
  const resetpassword({super.key, required this.mobilenumber});

  @override
  State<resetpassword> createState() => _reset_passwordState();
}

// ignore: camel_case_types
class _reset_passwordState extends State<resetpassword> {
  TextEditingController entercode = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  Timer? _timer;
  int _start = 60; // 60 seconds = 1 minute
  bool isLoading = false;
  //List<Registerresponse> responseData = []; // List to store parsed response data
  Map<String, dynamic> responseData = {}; // Map to store parsed response
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _obscureTextconform = true;
  bool _issending = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

// Retrieve data
  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _start = 60; // Reset the timer to 60 seconds
    });

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
        // Add your code here for when the timer completes
        print('Timer completed');
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> resetpasswordApi() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? userId = await getData('userId');
      var response = await apiService.resetPassword(
          userId!, entercode.text, password.text);

      setState(() {
        responseData = response;
      });

      int status = responseData["status"];
      String message = responseData["message"].toString();

      if (status == 200) {
        _showAlertwithPassword(
            context, "Alert", "Password updated successfully");
      } else {
        showToast(context, message);
      }
    } catch (e) {
      showToast(context, "Error occurred: $e");
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

  Future<void> forgotpasswordApi() async {
    setState(() {
      _issending = true;
    });

    try {
      var response =
          await apiService.forgotPassword(widget.mobilenumber, false);

      setState(() {
        responseData = response;
      });

      int status = responseData["status"];
      String message = responseData["message"].toString();

      if (status == 200) {
        var data = responseData["data"];
        saveData('userId', data["userId"].toString());
        startTimer();
        showToast(context, message);
      } else {
        showToast(context, message);
      }
    } catch (e) {
      showToast(context, "Error occurred: $e");
    } finally {
      setState(() {
        _issending = false;
      });
    }
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false; // No internet connection
    } else {
      return true; // Internet connection available
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset your password',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Appcolors.primary, // Change colors as needed
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              key: Key('oldPasswordField'),
              children: [
                TextFormField(
                  controller: entercode,
                  decoration: InputDecoration(
                    hintText: 'Verification code',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 13),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Verification code';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 27,
                ),
                TextFormField(
                  controller: password,
                  key: Key('newPasswordField'),
                  obscureText: _obscureText,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'new password',
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 13),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.length <= 8 ||
                        !value.contains(RegExp(r'[A-Z]')) ||
                        !value.contains(RegExp(r'[a-z]')) ||
                        !value.contains(RegExp(r'[0-9]')) ||
                        !value.contains(RegExp(r'[!@]'))) {
                      return 'Please enter a strong password ex Aabc@1234';
                    }
                    // Add more password validation if needed
                    return null;
                  },
                ),
                const SizedBox(height: 27),
                TextFormField(
                  controller: confirmpassword,
                  key: Key('confirmNewPasswordField'),
                  obscureText: _obscureTextconform,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureTextconform
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureTextconform = !_obscureTextconform;
                        });
                      },
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 13),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != password.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 36),
                GradientButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool isConnected = await checkInternetConnectivity();
                      if (isConnected) {
                        await resetpasswordApi();
                        // Internet connection is available
                      } else {
                        showToast(context, 'check your internet connection');
                      }
                    }
                  },
                  text: "Submit",
                  gradient: LinearGradient(
                    colors: Appcolors.buttoncolors,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Resend OTP in",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Text(
                      ' 00:$_start ',
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not received  an OTP ?",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    TextButton(
                        onPressed: _start > 0 ? null : forgotpasswordApi,
                        child: _issending
                            ? const SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                'Resend OTP',
                                style: TextStyle(
                                  color: _start > 0 ? Colors.grey : Colors.blue,
                                ),
                              ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }
}

void _showAlertwithPassword(
    BuildContext context, String alertMessage, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(alertMessage),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the alert dialog
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}
