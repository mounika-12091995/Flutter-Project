import 'package:Shubhvite/screens/authenticationpage/loginpage.dart';
import 'package:Shubhvite/screens/homepages/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//import 'package:Shubhvite/screens/homepages/events_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

final loginStatusProvider = FutureProvider<bool>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
});

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After 2 seconds, navigate to the home page
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AppNavigator()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use a Scaffold to provide background color
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Splash_screen.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Text(
              ' ',
              style: TextStyle(fontSize: 24.0, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class AppNavigator extends ConsumerWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(loginStatusProvider);

    return isLoggedIn.when(
      data: (loggedIn) {
        if (loggedIn) {
          // User is logged in, show EventScreenList
          return const GlobalTabScreen();
        } else {
          // User is not logged in, show LoginPage
          return LoginPage();
        }
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => const Text('Error loading login status'),
    );
  }
}
