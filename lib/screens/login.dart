import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:srm_notes/components/already_have_an_account_acheck.dart';
import 'package:srm_notes/components/rounded_button.dart';
import 'package:srm_notes/components/rounded_input_field.dart';
import 'package:srm_notes/components/rounded_password_field.dart';
import 'package:srm_notes/screens/HomePage.dart';
import 'package:srm_notes/screens/signup.dart';

import '../constants.dart';

class LoginScreen extends StatelessWidget {
  @override


  final _auth = FirebaseAuth.instance;
  String _email;
  String _pass;


  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_top.png",
                width: size.width * 0.35,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/images/login_bottom.png",
                width: size.width * 0.4,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "LOGIN",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(height: size.height * 0.03),
                  SvgPicture.asset(
                    "assets/icons/login.svg",
                    height: size.height * 0.35,
                  ),
                  SizedBox(height: size.height * 0.03),
                  RoundedEmailField(
                    hintText: "@srmist.edu.in",
                    onChanged: (value) {
                      _email = value;
                      print(_email);
                    },
                  ),
                  RoundedPasswordField(
                    hintText: "Password",
                    onChanged: (value) {
                      _pass = value;
                      print(_pass);
                    },
                  ),
                  RoundedButton(
                    text: "LOGIN",
                    press: () async{
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: _email, password: _pass);
                        if (user != null) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => HomePage()
                          ));
                        }
                        else
                        {
                          displayDialog(context, 'Error', 'No user found with corresponding email and password');
                        }
                      } catch (e) {
                        displayDialog(context, 'Error', 'Some error occured.');
                        print(e);
                      }
                    },
                  ),
                  SizedBox(height: size.height * 0.03),
                  AlreadyHaveAnAccountCheck(
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignUpScreen();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
