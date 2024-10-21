import 'package:Shubhvite/global/appcolors.dart';
import 'package:Shubhvite/screens/authenticationpage/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

//const platform1 = MethodChannel('com.progressiveitservices.Shubhvite/settings');
//const platform = MethodChannel('com.progressiveitservices.Shubhvite/settings');
const platform = MethodChannel('com.progressiveitservices.Shubhvite/settings');

Future<void> openSettings() async {
  try {
    await platform.invokeMethod('openSettings');
  } on PlatformException catch (e) {
    // Handle exception
    print("Failed to open settings: '${e.message}'.");
  }
}

// class SettingsService {
//   static const platform =
//       MethodChannel('com.progressiveitservices.Shubhvite/settings');

//   // Method to invoke the native Android method to open settings
//   static Future<void> openSettings() async {
//     try {
//       await platform.invokeMethod('openSettings');
//     } on PlatformException catch (e) {
//       // Handle exception
//       print("Failed to open settings: '${e.message}'.");
//     }
//   }
// }

class Biometricscreen extends StatelessWidget {
  const Biometricscreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Biometric Enable ',
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
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Do you want to configure your',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Face ID/ Fingerprint',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset('assets/Face.png'),
              const SizedBox(
                height: 20,
              ),
              const Text('Position your face with in the on-screen',
                  style: TextStyle(fontSize: 16.5)),
              SizedBox(
                height: 8,
              ),
              const Text(
                'frame to capture facial image',
                style: TextStyle(fontSize: 16.5),
              ),
              SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                height: 10,
              ),
              const Text('Place your finger on the designated sensor',
                  style: TextStyle(fontSize: 16.5)),
              SizedBox(
                height: 8,
              ),
              const Text(
                'area to register your unique fingerprints',
                style: TextStyle(fontSize: 16.5),
              ),
              const SizedBox(
                height: 29,
              ),
              ElevatedButton(
                onPressed: () {
                  openSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.Buttoncolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: const Size(double.infinity, 48.0),
                ),
                child: const Text(
                  'Enable now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          ),
        )),
      ),
    );
  }
}
