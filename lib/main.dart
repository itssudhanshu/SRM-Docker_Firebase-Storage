import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:srm_notes/components/bottonNavigation.dart';
import 'package:srm_notes/components/launcher.dart';
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
  bool doneLoading = false;

  checkForLoggedInUser() async {
    var _bool = await storage.read(key: 'isLogged');
    if (_bool == 'true') {
      print(_bool);
      setState(() {
        isLogged = true;
      });
    }
    setState(() {
      doneLoading = true;
    });
  }

  @override
  void initState() {
    checkForLoggedInUser();
    super.initState();
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
      home: doneLoading == true ? isLogged == false ? WelcomeScreen() : BottomNavigation() : Launcher(),
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
