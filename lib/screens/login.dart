import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:srm_notes/components/already_have_an_account_acheck.dart';
import 'package:srm_notes/components/rounded_button.dart';
import 'package:srm_notes/screens/HomePage.dart';
import 'package:srm_notes/screens/signup.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  final _auth = FirebaseAuth.instance;

  String _email;

  String _pass;

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: Icon(null),
        backgroundColor: kPrimaryColor,
        title: Center(
          child: Text(
            "LOGIN",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
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
                  SizedBox(height: size.height * 0.03),
                  SvgPicture.asset(
                    "assets/icons/login.svg",
                    height: size.height * 0.35,
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    width: size.width * 0.8,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                            decoration: InputDecoration(
                              fillColor: kPrimaryLightColor,
                              filled: true,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(29),
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(29),
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.purple)),
                              hintText: "Enter your college id",
                              labelText: "Email",
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.mail,
                                  color: kPrimaryColor,
                                ), // icon is 48px widget.
                              ),
                            ),
                            onChanged: (val) {
                              _email = val;
                            }),
                        SizedBox(height: 20.0),
                        TextFormField(
                            decoration: InputDecoration(
                              fillColor: kPrimaryLightColor,
                              filled: true,
                              contentPadding:
                                  new EdgeInsets.symmetric(vertical: 0.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(29),
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.green)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(29),
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.purple)),
                              hintText: "Enter password",
                              labelText: "Password",
                              suffixIcon: Container(
                                child: IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      _toggle();
                                    }),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: kPrimaryColor,
                              ),
                            ),
                            obscureText: _obscureText,
                            onChanged: (valpass) {
                              _pass = valpass;
                            }),
                        SizedBox(height: 20.0),
                        RoundedButton(
                          text: "LOGIN",
                          press: () async {
                            try {
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: _email, password: _pass);
                              if (user != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              } else {
                                displayDialog(context, 'Error',
                                    'No user found with corresponding email and password');
                              }
                            } catch (e) {
                              displayDialog(
                                  context, 'Error', 'Some error occured.');
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
          ],
        ),
      ),
    );
  }
}
