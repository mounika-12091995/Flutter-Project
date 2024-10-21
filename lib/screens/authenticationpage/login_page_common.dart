import 'dart:io';

import 'package:Shubhvite/model/api_calls.dart';
import 'package:Shubhvite/screens/homepages/TermsAndConditions.dart';
import 'package:Shubhvite/screens/homepages/privacyPolicy.dart';
import 'package:Shubhvite/screens/authenticationpage/forgotpassword.dart';
import 'package:Shubhvite/screens/authenticationpage/signuppage.dart';
import 'package:Shubhvite/screens/homepages/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:Shubhvite/Common/utils.dart'; // Import the utility file

class Login_page_helper extends StatefulWidget {
  @override
  State<Login_page_helper> createState() => _Login_page_helperState();
}

class _Login_page_helperState extends State<Login_page_helper> {
  late final LocalAuthentication _auth;
  bool isLoading = false;
  late String mobileNumber;
  String phoneNumber = '';
  String platformName = '';
  String commonphone = "";
  String? firstName = '';
  String? lastName = '';
  String? email = '';
  String? idToken = '';

  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _isAuthenticated = false;
  String _authMessage = '';

  Map<String, dynamic> responseData = {};
  @override
  void initState() {
    super.initState();
    _auth = LocalAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const forgotpassword(), // Replace with your home page
                  ),
                );
              },
              child: const Text(
                'Forgot Password ?',
                style: TextStyle(
                  color: Color.fromARGB(221, 7, 95, 247),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 22,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  onTap: () => _authenticate(),
                  child: Image.asset('assets/Face.png')),
            ],
          ),
          const SizedBox(
            height: 17,
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
            height: 18,
          ),
          //        TextButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => PrivacyPolicy(), // Navigate to Privacy Policy page
          //       ),
          //     );
          //   },
          //   child: const Text(
          //     'Privacy Policy',
          //     style: TextStyle(
          //       color: Color.fromARGB(221, 7, 95, 247),
          //       fontSize: 16,
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 22,
          ),
          Text(
            '   Sign in with below account',
            style: TextStyle(fontWeight: FontWeight.w500),
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
                  borderRadius: BorderRadius.circular(30), // Set border radius
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
                  borderRadius: BorderRadius.circular(30), // Set border radius
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
                  borderRadius: BorderRadius.circular(30), // Set border radius
                ),
              ),
            ],
          ),
          SizedBox(
            height: 19,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                "New user?",
                style: TextStyle(
                    color: Color.fromARGB(255, 32, 32, 32),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: const Text(
                  "Sign up",
                  style: TextStyle(
                    color: Color.fromARGB(255, 44, 120, 234),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text(' here',
                  style: TextStyle(
                      color: Color.fromARGB(255, 18, 18, 18),
                      fontWeight: FontWeight.w500))
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _loginWithFacebook() async {
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      // final LoginResult result = await FacebookAuth.instance.login();

      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        print("userdata  : $userData");
        //_userData?['name'] ?? 'No name available';

        if (Platform.isIOS) {
          firstName = userData['first_name'] ?? 'No name available';
          lastName = userData['last_name'];
          email = userData['email'];
        } else {
          firstName = userData['name'] ?? 'No name available';
          lastName = userData['name'];
          email = userData['email'];
        }
        idToken = result.accessToken!.tokenString;

        loginWithSocialApi(idToken!, "FACEBOOK");
        //final String accessToken = result.accessToken!.tokenString;
        // printLargeString(accessToken);

        // _token = result.accessToken!.tokenString;
        // User is logged in
        // await _getUserProfile(); // Retrieve user information
      } else {
        print('Failed to log in: ${result.message}');
      }
    } catch (e) {
      print('Error logging in: $e');
    }
  }

  Future<void> _getUserProfile() async {
    try {
      final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
      if (accessToken != null) {
        final userData = await FacebookAuth.instance.getUserData();
        final String firstName = userData['first_name'];
        final String lastName = userData['last_name'];
        final String email = userData['email'];

        print('First Name: $firstName');
        print('Last Name: $lastName');
        print('Email: $email');

        loginWithSocialApi(accessToken.tokenString, "FACEBOOK");
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  void printLongToken(String token) {
    const int chunkSize =
        1000; // Define chunk size (100 characters in this case)
    for (int i = 0; i < token.length; i += chunkSize) {
      print(token.substring(
          i, i + chunkSize > token.length ? token.length : i + chunkSize));
    }
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> _toggleFaceID(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('faceIDEnabled', value);
  }

  Future<void> _loadFaceIDPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //_isFaceIDEnabled = prefs.getBool('faceIDEnabled') ?? false;
    });
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await _auth.authenticate(
        localizedReason: 'For event-based app',
      );

      if (authenticated) {
        // If authentication is successful, navigate to the new page
        await _setLoginStatus(true);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const GlobalTabScreen(),
          ),
        );
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
  // Future<void> _authenticate() async {
  //   try {

  //     // If authentication is successful, navigate to the new page
  //       String? token = await getData('token');
  //       String? userID = await getData('userId');
  //       if (token != null && token.isNotEmpty ||
  //           userID != null && userID.isNotEmpty) {
  //         await _setLoginStatus(true);

  //         Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(
  //             builder: (context) => const GlobalTabScreen(),
  //           ),
  //         );
  //       } else {
  //         showToast(context, "Please register with your Email id or Phone no");
  //       }

  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> _setLoginStatus(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      isLoading = true;
    });
    try {
      // Perform Google sign-in
      GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

      if (googleSignInAccount != null) {
        // Perform authentication
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        idToken = googleSignInAuthentication.idToken;
        List<String>? nameParts = googleSignInAccount.displayName?.split(' ');
        firstName =
            nameParts != null && nameParts.isNotEmpty ? nameParts[0] : '';
        lastName =
            nameParts != null && nameParts.length > 1 ? nameParts[1] : '';
        email = googleSignInAccount.email;

        // Call your login API with the idToken
        loginWithSocialApi(idToken!, "google");

        // Sign out the user
        await GoogleSignIn().signOut();

        // Update the state after signing out
      }
    } catch (error) {
      print("Error during Google Sign In: $error");
    }
    setState(() {
      isLoading = false;
    });
  }

  void printLargeString(String text) {
    const int chunkSize = 800; // Define the chunk size
    for (int i = 0; i < text.length; i += chunkSize) {
      print(text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize));
    }
  }

  Future<void> loginWithSocialApi(String idToken, String provider) async {
    setState(() {
      isLoading = true; // Show activity indicator
    });

    await Future.delayed(Duration(seconds: 2));

    try {
      Map<String, dynamic> response =
          await apiService.loginWithSocial(idToken, provider);

      if (response['status'] == 200) {
        setState(() {
          responseData = response;
        });

        String message = responseData['message'].toString();
        print("Response: $message");
        Map<String, dynamic> data = responseData['data'];

        String token = data['token'].toString();
        String userID = data['userId'].toString();
        String refreshToken = data['refreshToken'].toString();
        String firstName = data['firstName'].toString();
        String email = data['email'].toString();
        String phoneNo = data['phoneNo'].toString();

        showToast(context, message);

        saveData('token', token);
        saveData('userId', userID);
        saveData('refreshToken', refreshToken);
        saveData('firstName', firstName);
        saveData('email', email);
        saveData('phoneNo', phoneNo);

        commonphone = phoneNo;

        _verifyOTP();
      } else {
        if (response['errorMsg'] == "User_Not_Found") {
          socialRegisterApi(firstName!, lastName!, email!, provider);
        }
      }
    } catch (e) {
      print('Exception: $e');
      showToast(context, 'Failed to login with social account');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
        loginWithSocialApi(idToken!, provider);
      } else {
        //String message = responseData["errorMsg"].toString();
        // showToast(context, message);
      }
    } catch (e) {
      // String message = responseData["errorMsg"].toString();
      // showToast(context, "$message");
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

  Future<void> _verifyOTP() async {
    await _setLoginStatus(true);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GlobalTabScreen(), // Replace with your login page
        ),
        (route) => false);
  }
}
