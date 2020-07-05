import 'package:flutter/material.dart';
import 'package:srm_notes/components/rounded_button.dart';
import 'package:srm_notes/constants.dart';
import 'package:srm_notes/screens/login.dart';
import 'package:srm_notes/screens/signup.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_top.png",
                width: size.width * 0.3,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_bottom.png",
                width: size.width * 0.2,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                   Text("SRM",
                 style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                ),
                Opacity(opacity: 0.8,child: 
                Text("DOCKER",
                 style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                )
                ),
                  // SizedBox(height: size.height * 0.10),
                  // SvgPicture.asset(
                  //   "assets/icons/chat.svg",
                  //   height: size.height * 0.45,
                  // ),
                  Container(
                      width: size.width * 0.8,
                      child: Image.asset('assets/images/logobg.png',
                          fit: BoxFit.cover)),
                  SizedBox(height: size.height * 0.05),
                  RoundedButton(
                    text: "SIGN IN",
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                  ),
                  RoundedButton(
                    text: "SIGN UP",
                    color: kPrimaryLightColor,
                    textColor: Colors.black,
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
