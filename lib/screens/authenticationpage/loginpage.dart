import 'package:Shubhvite/global/appcolors.dart';
import 'package:Shubhvite/model/api_calls.dart';
import 'package:Shubhvite/screens/authenticationpage/login_page_common.dart';
import 'package:Shubhvite/screens/homepages/tabbar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../../global/primary_Button.dart';
import 'package:Shubhvite/Common/utils.dart'; // Import the utility file
import 'package:Shubhvite/screens/homepages/privacyPolicy.dart';

final loginStatusProvider = FutureProvider<bool>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
});

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> responseData = {}; // Map to store parsed response

  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _emailPasswordController =
      TextEditingController();
  bool _obscureTextemail = true;
  final TextEditingController _phonePasswordController =
      TextEditingController();
  bool _obscureTextphone = true;
  String phoneNumber = '';
  String platformName = '';
  String dialCode = '+91'; // Set default dial code to 91
  String selectedCountry = 'IN'; // Set default country to India
  Logger logger = Logger();
  String commonphone = "";

  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();

  late TabController _tabController;

  late String mobileNumber;

  bool isLoading = false;
  bool _rememberMe = false;
  bool _rememberme = false;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String? _emailError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _loadSavedCredentials();
    _loadPhoneNumberCredential();

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        // Validate email when it loses focus
        _validateEmailField();
      }
    });
  }

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _emailPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validateEmailField() {
    setState(() {
      if (!_validateEmail(_emailOrPhoneController.text)) {
        _emailError = 'Please enter a valid email';
      } else {
        _emailError = null;
      }
    });
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool rememberMeValue = pref.getBool('remember_me') ?? false;

    setState(() {
      _rememberMe = rememberMeValue;
      if (_rememberMe) {
        _emailOrPhoneController.text = pref.getString('username') ?? '';

        _emailPasswordController.text = pref.getString('password') ?? '';
      }
    });
  }

  Future<void> _loadPhoneNumberCredential() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool rememberMevalue = pref.getBool('remember_me') ?? false;
    setState(() {
      _rememberme = rememberMevalue;
      if (_rememberme) {
        mobileNumber = pref.getString('Phonenumber') ?? '';

        _phonePasswordController.text =
            pref.getString('Phonenumberpassword') ?? '';
      }
    });
  }

  Future<void> _saveCredentials() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('remember_me', true);

    await pref.setString('username', _emailOrPhoneController.text);
    await pref.setString('password', _emailPasswordController.text);
  }

  Future<void> savemoblie() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('phonenumber', commonphone);
    print('manu$commonphone');
  }

  Future<void> _loadData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('remember_me', true);
    setState(() {
      if (_emailOrPhoneController.text.isNotEmpty &&
          _emailPasswordController.text.isNotEmpty) {
        return;
      }
      _emailOrPhoneController.text = pref.getString('username') ?? '';

      _emailPasswordController.text = pref.getString('password') ?? '';
    });
  }

  Future<void> _loadPhoneData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('remember_me', true);
    setState(() {
      if (mobileNumber.isNotEmpty || _phonePasswordController.text.isNotEmpty) {
        return;
      }
      mobileNumber = pref.getString('Phonenumber') ?? '';

      _phonePasswordController.text =
          pref.getString('Phonenumberpassword') ?? '';
    });
  }

  Future<void> _savePhonenumberCredential() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('remember_me', true);
    await pref.setString('Phonenumber', mobileNumber);
    await pref.setString('Phonenumberpassword', _phonePasswordController.text);
  }

  Future<void> _clearSavedCredentials() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('remember_me', false);
    // await pref.remove('username');
    // await pref.remove('password');
    _emailOrPhoneController.text = "";
    _emailPasswordController.text = "";
  }

  Future<void> clearPhonenumberCredential() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('remember_me', false);

    phoneNumber = "";
    _phonePasswordController.text = "";
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false; // No internet connection
    } else {
      return true; // Internet connection available
    }
  }

// Login API Call

// Save data
  Future<void> saveData(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  Future<void> loginWithMobile() async {
    mobileNumber = phoneNumber.toString();
    await login(mobileNumber, _phonePasswordController.text.toString());
  }

  Future<void> loginWithEmail() async {
    await login(_emailOrPhoneController.text.toString(),
        _emailPasswordController.text.toString());
  }

  Future<void> login(String username, String password) async {
    setState(() {
      isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      Map<String, dynamic> response =
          await apiService.login(username, password);

      if (response['status'] == 200) {
        setState(() {
          responseData = response;
        });

        String message = responseData['message'].toString();
        Map<String, dynamic> data = responseData['data'];

        String token = data['token'].toString();
        String userID = data['userId'].toString();
        String refreshToken = data['refreshToken'].toString();
        String firstName = data['firstName'].toString();
        String email = data['email'].toString();
        String phoneNo = data['phoneNo'].toString();

        saveData('token', token);
        saveData('userId', userID);
        saveData('refreshToken', refreshToken);
        saveData('firstName', firstName);
        saveData('email', email);
        saveData('phoneNo', phoneNo);

        // showToast(context, message);

        //  showToast(context, 'Hello, this is a reusable toast!');
        _verifyOTP();
      } else {
        showToast(context, response['errorMsg']);
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<void> _setLoginStatus(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> _verifyOTP() async {
    // Mock OTP verification process (replace with actual logic)
    // await Future.delayed(const Duration(seconds: 2));

    if (_rememberMe) {
      await _saveCredentials();
    }
    if (_rememberme) {
      await _savePhonenumberCredential();
    }

    await _setLoginStatus(true);

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GlobalTabScreen(), // Replace with your login page
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  child: Image.asset(
                    "assets/homelogo.jpg",
                    fit: BoxFit.cover,
                    width: 250,
                    height: 250,
                  ),
                  radius: 70,
                ),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.red,
                  //indicator: ,

                  labelColor: Colors
                      .blue, // Change this to the color you desire for active text
                  unselectedLabelColor: Color.fromARGB(255, 35, 35, 35),
                  tabs: const [
                    Tab(
                      child: Text(
                        'Email',
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Mobile',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.81,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Form(
                        key: _emailFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _emailOrPhoneController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              focusNode: _emailFocusNode,
                              key: Key('emailField'),
                              decoration: InputDecoration(
                                hintText: 'Enter your email id',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 25, 25, 25),
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                errorText: _emailError,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            TextFormField(
                              controller: _emailPasswordController,
                              obscureText: _obscureTextemail,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              focusNode: _passwordFocusNode,
                              key: Key('passwordField'),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                filled: true,
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureTextemail
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _obscureTextemail = !_obscureTextemail;
                                    });
                                  },
                                ),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  activeColor: Colors.blue,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value!;

                                      if (!_rememberMe) {
                                        _clearSavedCredentials();
                                      } else {
                                        // _loadSavedCredentials();
                                        //  _saveCredentials();
                                        _loadData();
                                      }
                                    });
                                  },
                                ),
                                Text('Remember Me'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            GradientButton(
                              onPressed: () async {
                                if (_emailFormKey.currentState!.validate()) {
                                  bool isConnected =
                                      await checkInternetConnectivity();
                                  if (isConnected) {
                                    await loginWithEmail();
                                    savemoblie();
                                    // Internet connection is available
                                  } else {
                                    showToast(
                                      context,
                                      'Internet connection is not available',
                                    );
                                  }
                                }
                              },
                              text: 'Sign in',
                              gradient: LinearGradient(
                                  colors: Appcolors.buttoncolors),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(child: Login_page_helper())
                          ],
                        ),
                      ),
                      // Content for the first tab
                      Form(
                        key: _phoneFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 60,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Colors.grey), // Add border color here
                                borderRadius: BorderRadius.circular(30.0),
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
                                          selectedCountry = number.isoCode!;
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
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 17),
                            TextFormField(
                              controller: _phonePasswordController,
                              obscureText: _obscureTextphone,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                filled: true,
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureTextphone
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _obscureTextphone = !_obscureTextphone;
                                    });
                                  },
                                ),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberme,
                                  activeColor: Colors.blue,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberme = value!;
                                      if (!_rememberme) {
                                        clearPhonenumberCredential();
                                      } else {
                                        // _savePhonenumberCredential();
                                        _loadPhoneData();
                                      }
                                    });
                                  },
                                ),
                                Text('Remember Me'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            GradientButton(
                              onPressed: () async {
                                if (_phoneFormKey.currentState!.validate()) {
                                  await loginWithMobile(); // Assuming this is a function call to handle login logic
                                }
                              },
                              text: 'Sign in',
                              gradient: LinearGradient(
                                  colors: Appcolors.buttoncolors),
                            ),
                            SizedBox(
                              height: 10,
                            ),                            
                            Expanded(child: Login_page_helper()),                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}


