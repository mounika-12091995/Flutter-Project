import 'dart:async';
import 'dart:io';

import 'package:Shubhvite/global/appcolors.dart';
import 'package:Shubhvite/global/primary_Button.dart';
import 'package:Shubhvite/global/secound_primary_button.dart';
import 'package:Shubhvite/model/api_calls.dart';
import 'package:Shubhvite/screens/authenticationpage/Biometric_screen.dart';
import 'package:Shubhvite/screens/authenticationpage/loginpage.dart';
import 'package:Shubhvite/screens/homepages/TermsAndConditions.dart';
import 'package:Shubhvite/screens/homepages/privacyPolicy.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:Shubhvite/Common/utils.dart'; // Import the utility file
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter/gestures.dart';

String userID = "";

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  bool isLoading = false;

  Map<String, dynamic> responseData = {}; // Map to store parsed response

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  TextEditingController password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController(); //added
  String phoneNumber = '';
  String dialCode = '+91'; // Set default dial code to 91
  String selectedCountry = 'IN';
  // Set default country to India
  final TextEditingController _MiddleName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = false;
  String numberWithoutDialCode = '';
  bool _obscureText = true;
  bool _obscureTextconform = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    password.dispose();
    _confirmpassword.dispose();

    _MiddleName.dispose();
    _companyNameController.dispose(); //added
    super.dispose();
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false; // No internet connection
    } else {
      return true; // Internet connection available
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      print("googleSignInAccount $googleSignInAccount");

      if (googleSignInAccount != null) {
        print("Started");
        // Get user info
        List<String>? nameParts = googleSignInAccount.displayName?.split(' ');
        String? firstName =
            nameParts != null && nameParts.isNotEmpty ? nameParts[0] : '';
        String? lastName =
            nameParts != null && nameParts.length > 1 ? nameParts[1] : '';
        String? email = googleSignInAccount.email;

        print("Values are: $firstName , $lastName, $email");

        // Ensure the first name, last name, and email are not null before calling the API

        await socialRegisterApi(firstName, lastName, email, "google");
      }
    } catch (error) {
      print("Error during Google Sign In: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create an account',
            style: TextStyle(color: Color.fromRGBO(251, 252, 253, 0.965)),
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
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: _firstNameController,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9\s]{1,100}'),
                        )
                      ],
                      decoration: InputDecoration(
                        hintText: 'First name',
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
                          return 'First name cannot be empty';
                        } else if (value.length >= 100) {
                          return 'first name allow max 100';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 19),
                    TextFormField(
                      controller: _MiddleName,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9\s]'),
                        ), // Allow only alphabets
                      ],
                      decoration: InputDecoration(
                        hintText: 'Middle name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(27.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 13),
                      ),
                      validator: (value) {
                        if (value!.length >= 100) {
                          return 'Middle name allow max 100';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 19),
                    TextFormField(
                      controller: _lastNameController,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9\s]{1,100}'),
                        ), // Allow only alphabets
                      ],
                      decoration: InputDecoration(
                        hintText: 'Last name',
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
                          return 'Last name cannot be empty';
                        } else if (value.length >= 100) {
                          return 'Last name allow max 100';
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
                      controller:  _companyNameController,
                                          keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9\s]{1,100}'),
                        )
                      ],
                        decoration: InputDecoration(
                          hintText: 'Company Name',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 13 )
                        ),
                        validator: (value){
                          if(value ==null || value.isEmpty){
                            return 'Company Name cannot be empty';
                          }
                          if(value.length> 100){
                            return 'Company Name allow max 100';
                          }
                          return null;
                        },     
                    ),
                    const SizedBox(height: 19),

                    Container(
                      height: 60,
                      padding:
                          EdgeInsets.symmetric(horizontal: 19, vertical: 0),
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
                              initialValue:
                                  PhoneNumber(isoCode: selectedCountry),
                              onInputChanged: (PhoneNumber number) {
                                setState(() {
                                  phoneNumber = number.phoneNumber!;
                                  print('maheshphone$phoneNumber');
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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
                    const SizedBox(height: 19),
                    TextFormField(
                      controller: password,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'Password',
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
                        fillColor: Colors.white,
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
                          return 'Enter a strong password ex Aabc@1234';
                        }
                        // Add more password validation if needed
                        return null;
                      },
                    ),
                    const SizedBox(height: 19),
                    TextFormField(
                      controller: _confirmpassword,
                      obscureText: _obscureTextconform,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'Confirm password ',
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
                          return 'Confirm your password';
                        } else if (value != password.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align checkbox with text
                      children: [
                        // Checkbox at the start
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (bool? value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                          activeColor: Colors.blue,
                          checkColor: Colors.white,
                        ),

                        // Wrapping text and buttons in a row
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16), // Default text style
                              children: [
                                const TextSpan(
                                    text:
                                        "I have read and agree to the "), // Static text

                                // Privacy Policy as a TextButton
                                WidgetSpan(
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets
                                          .zero, // Remove padding for proper alignment
                                      minimumSize: Size(0,
                                          0), // Set minimum size to zero to avoid extra space
                                      tapTargetSize: MaterialTapTargetSize
                                          .shrinkWrap, // Remove extra clickable area
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PrivacyPolicy()));
                                    },
                                    child: const Text(
                                      "Privacy Policy",
                                      style: TextStyle(
                                        color: Color.fromRGBO(8, 120, 248, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                const TextSpan(text: ". Our "), // Static text

                                // Terms and Conditions as a TextButton
                                WidgetSpan(
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets
                                          .zero, // Remove padding for proper alignment
                                      minimumSize: Size(0,
                                          0), // Set minimum size to zero to avoid extra space
                                      tapTargetSize: MaterialTapTargetSize
                                          .shrinkWrap, // Remove extra clickable area
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Termsandconditions()));
                                    },
                                    child: const Text(
                                      "Terms and Conditions",
                                      style: TextStyle(
                                        color: Color.fromRGBO(8, 120, 248, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                const TextSpan(text: " apply."), // Static text
                              ],
                            ),
                          ),
                        ),
                      ],
                    ), 
                    const SizedBox(height: 19),
                    //  Row(
                    //   children: [
                    //     Checkbox(value: _agreeToTerms, onChanged: (bool? value){
                    //       setState(() {
                    //       _agreeToTerms = value ?? false;
                    //       });
                    //     },
                    //     activeColor: Colors.blue,
                    //     checkColor: Colors.white,
                    //     ),
                    //     Text("i have read and agree to the"),
                    //     TextButton(onPressed: (){}, child: Text("Privacy Policy"),),
                    //     Text(".Our"),
                    //     TextButton(onPressed: (){}, child: Text("Terms and Conditions")),
                    //     Text("apply.")
                    //   ],
                    //  ),

                    secoundButton(
                      onPressed: () async {
                        if (!_agreeToTerms) {
                          showToast(context,
                              'You must read and agree to the Privacy Policy and Terms & Conditions');
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          bool isConnected = await checkInternetConnectivity();
                          numberWithoutDialCode =
                              phoneNumber.replaceAll(dialCode, '');
                          numberWithoutDialCode =
                              numberWithoutDialCode.replaceAll('', '');

                          if (isConnected) {
                            await registerApi();
                            // Internet connection is available
                          } else {
                            showToast(
                              context,
                              'Internet connection is not available',
                            );
                          }
                        }
                      },
                      text: "Create an account",
                      gradient: LinearGradient(
                        colors: Appcolors.buttoncolors,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                              color: Color.fromARGB(255, 17, 17, 17),
                              fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            " Sign in",
                            style: TextStyle(
                                color: Color.fromRGBO(8, 120, 248, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Or',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '   Sign in with below accounts',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // Set border color
                              width: 1, // Set border width
                            ),
                            borderRadius:
                                BorderRadius.circular(30), // Set border radius
                          ),
                          child: IconButton(
                            onPressed: () => _signInWithGoogle(context),
                            icon: Image.asset(
                              'assets/Google.png',
                              width: 92, // Set desired width
                              height: 39,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // Set border color
                              width: 1, // Set border width
                            ),
                            borderRadius:
                                BorderRadius.circular(30), // Set border radius
                          ),
                          child: Align(
                            widthFactor: BorderSide.strokeAlignOutside,
                            child: IconButton(
                              onPressed: _loginWithFacebook,
                              icon: Image.asset(
                                'assets/Facebook.png',
                                width: 92, // Set desired width
                                height: 39,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // Set border color
                              width: 1, // Set border width
                            ),
                            borderRadius:
                                BorderRadius.circular(30), // Set border radius
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _loginWithFacebook() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      print("Login1");
      if (result.status == LoginStatus.success) {
        print("Login2");
        // User is logged in
        await _getUserProfile(); // Retrieve user information
      } else {
        print('Failed to log in: ${result.message}');
      }
    } catch (e) {
      print('Error logging in: $e');
    }
  }

  Future<void> _getUserProfile() async {
    print("Login3");
    try {
      final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
      if (accessToken != null) {
        print("Login4");
        final userData = await FacebookAuth.instance.getUserData();
        print("userdata  : $userData");
        //_userData?['name'] ?? 'No name available';

        String firstName = "";
        String lastName = "";
        String email = "";
        if (Platform.isIOS) {
          firstName = userData['first_name'] ?? 'No name available';
          lastName = userData['last_name'];
          email = userData['email'];
        } else {
          firstName = userData['name'] ?? 'No name available';
          lastName = userData['name'];
          email = userData['email'];
        }
        print('First Name: $firstName');
        print('Last Name: $lastName');
        print('Email: $email');

        await socialRegisterApi(firstName, lastName, email, "FACEBOOK");
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  bool isMobileNumberValid(String? value) {
    final RegExp regex = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    if (value == null) return false;
    return regex.hasMatch(value);
  }

  bool _validateEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

// Save data
  Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

// Retrieve data
  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> socialRegisterApi(
      String firstName, String lastName, String email, String provider) async {
    setState(() {
      isLoading = true;
    });

    try {
      var response =
          await apiService.socialRegister(firstName, lastName, email, provider);

      setState(() {
        responseData = response;
      });

      print("Response $responseData");

      String message = responseData["message"].toString();
      print("message $message");
      int status = responseData["status"];

      if (status == 200) {
        Map<String, dynamic> data = responseData["data"];
        userID = data["id"].toString();
        saveData('userId', userID);

        showToast(context, message);

        Navigator.pop(context);
      } else {
        String message = responseData["errorMsg"].toString();
        showToast(context, message);
      }
    } catch (e) {
      String message = responseData["errorMsg"].toString();
      showToast(context, "$message");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> registerApi() async {
    setState(() {
      isLoading = true;
    });

    try {
      // String companyName = _companyNameController.text;   //added
      // print('"company Name: $companyName');        //added

      var response = await apiService.registerUser(
        _firstNameController.text,
        _lastNameController.text,
        _MiddleName.text,
        _emailController.text,
        password.text,
        numberWithoutDialCode,
        selectedCountry,
        dialCode,
        _companyNameController.text,  //added
      );

      setState(() {
        responseData = response;
      });

      String message = responseData["message"].toString();
      int status = responseData["status"];
      if (status == 200) {
        Map<String, dynamic> data = responseData["data"];
        userID = data["id"].toString();
        saveData('userId', userID);

        showToast(context, message);

        _enterOtp();
      } else {
        showToast(context, message);
      }
    } catch (e) {
      showToast(context, "Exception occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _enterOtp() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OtpScreen(phoneNumber: _emailController.text)));
  }
}

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  OtpScreen({required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreen(phoneNumber: phoneNumber);
}

class _OtpScreen extends State<OtpScreen> {
  final String phoneNumber;
  Map<String, dynamic> responseData = {};

  _OtpScreen({required this.phoneNumber});
  String otpPin = "";
  String countryDial = "+91";
  Timer? _timer;
  int _start = 60; // 60 seconds = 1 minute
  Color primaryColor = const Color(0xff0074E4);

  bool isOTPLoading = false;
  late final LocalAuthentication auth;
  String? otpError;

  Future<void> verifyPhone(String number) async {
    // Mock verification process (replace with your desired logic)
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  Future<void> forgotPasswordApi() async {
    setState(() {
      isOTPLoading = true;
    });

    try {
      var response = await apiService.forgotPassword(phoneNumber, false);

      setState(() {
        responseData = response;
      });

      String message = responseData["message"].toString();
      int status = responseData["status"];
      if (status == 200) {
        showToast(context, message);
        startTimer();
      } else {
        showToast(context, message);
      }
    } catch (e) {
      showToast(context, "Exception occurred: $e");
    } finally {
      setState(() {
        isOTPLoading = false;
      });
    }
  }

  Future<void> verifyOtpApi() async {
    setState(() {
      isOTPLoading = true;
    });

    try {
      var response = await apiService.verifyOtp(otpPin, userID);

      setState(() {
        responseData = response;
      });

      int status = responseData["status"];
      String message = responseData["message"];
      if (status == 200) {
        _showAlertwithPassword(context, "Alert", message);
      } else {
        showToast(context, message);
      }
    } catch (e) {
      showToast(context, "Exception occurred: $e");
    } finally {
      setState(() {
        isOTPLoading = false;
      });
    }
  }

  void _showAlertwithPassword(
      BuildContext context, String alertMessage, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertMessage),
          content: Text(message), // Use the provided message parameter
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
                verifyOTP();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> verifyOTP() async {
    await Future.delayed(const Duration(seconds: 2));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Biometricscreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verification code',
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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),

                    const SizedBox(
                      height: 17,
                    ),

                    // Uncomment the following line to enable OTP input
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          otpPin = value;
                        });
                      },
                      pinTheme: PinTheme(
                          activeColor: primaryColor,
                          selectedColor: primaryColor,
                          inactiveColor: Color.fromARGB(255, 15, 15, 15),
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(13)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text:
                                "Verification code sent to be mobile number or email",
                            style: TextStyle(
                                color: Color.fromARGB(221, 21, 20, 20),
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    GradientButton(
                      onPressed: () async {
                        if (otpPin.length != 6) {
                          setState(() {
                            otpError = 'Please enter a valid OTP';
                          });
                        } else {
                          setState(() {
                            otpError = null;
                            isOTPLoading = true;
                          });
                          bool isConnected = await checkInternetConnectivity();
                          if (isConnected) {
                            await verifyOtpApi();
                            // Internet connection is available
                          } else {
                            showToast(context, 'please check theinter net');
                          }
                        }
                      },
                      text: "Verify",
                      gradient: LinearGradient(
                        colors: Appcolors.buttoncolors,
                      ),
                    ),

                    if (otpError !=
                        null) // Display error message if otpError is not null
                      Text(
                        otpError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Resend OTP in",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17)),
                        Text(
                          ' 00:$_start ',
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ),

                    TextButton(
                      onPressed: _start > 0 ? null : forgotPasswordApi,
                      child: isOTPLoading
                          ? const SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              'Resend the code',
                              style: TextStyle(
                                  color: _start > 0 ? Colors.grey : Colors.blue,
                                  fontSize: 17),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false; // No internet connection
    } else {
      return true; // Internet connection available
    }
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
