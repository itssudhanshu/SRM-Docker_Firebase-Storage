import 'package:flutter/material.dart';
import 'package:srm_notes/components/bottonNavigation.dart';
import 'package:srm_notes/constants.dart';
import 'package:srm_notes/screens/HomePage.dart';
import 'package:srm_notes/screens/login.dart';
import 'package:srm_notes/screens/signup.dart';
import 'package:srm_notes/screens/welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SRM Helper',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      // home: WelcomeScreen(),
      initialRoute: "/welcome",
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomePage(),
        '/welcome': (context) => WelcomeScreen(),
        '/bottomnav': (context) => BottomNavigation(),
      },

    );
  }
}

