import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:srm_notes/components/bottonNavigation.dart';
import 'package:srm_notes/constants.dart';
import 'package:srm_notes/screens/HomePage.dart';
import 'package:srm_notes/screens/login.dart';
import 'package:srm_notes/screens/signup.dart';
import 'package:srm_notes/screens/welcome.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var storage = FlutterSecureStorage();
  bool isLogged = false;

  checkForLoggedInUser () async {
    var _bool = await storage.read(key: 'isLogged');
    if(_bool == 'true')
    {
      print(_bool);
      setState(() {
        isLogged = true;
      });
    }
  }

  void initState()  {
     checkForLoggedInUser();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SRM Helper',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isLogged == false ? WelcomeScreen() : BottomNavigation() ,
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

