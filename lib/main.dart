import 'package:flutter/material.dart';
import 'package:srm_notes/constants.dart';
import 'package:srm_notes/screens/welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//      return StreamProvider<User>.value(
//       value: AuthService().user,
//           child: MaterialApp(
//        debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//         primaryColor: kPrimaryColor,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//        home: WelcomeScreen(),
//       ),
//     );
//   }
