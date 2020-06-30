import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:srm_notes/components/already_have_an_account_acheck.dart';
import 'package:srm_notes/components/models/loading.dart';
import 'package:srm_notes/components/rounded_button.dart';
import 'package:srm_notes/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool forgpass = false;
  Size size;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final _auth = FirebaseAuth.instance;
  var storage = FlutterSecureStorage();
  String _email;
  String _pass;
  bool isSpinner = false;

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return isSpinner
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              // leading: Icon(null),
              backgroundColor: Colors.transparent,
              title: Center(
                child: Text(
                  forgpass ? "RESET PASSWORD" : "SIGN IN",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                      letterSpacing: 2.0),
                ),
              ),
            ),
            body: Container(
              child: forgpass ? forgpassw() : login(),
            ),
          );
  }

  Widget login() {
    Size size = MediaQuery.of(context).size;
    return Container(
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
                // SvgPicture.asset(
                //   "assets/icons/login.svg",
                //   height: size.height * 0.35,
                // ),
                Container(
                  child: Image.asset('assets/images/docker_logo.png'),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  width: size.width * 0.8,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            fillColor: kPrimaryLightColor,
                            filled: true,
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(29),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(29),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.purple)),
                            hintText: "Enter your college email id",
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
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            fillColor: kPrimaryLightColor,
                            filled: true,
                            contentPadding:
                                new EdgeInsets.symmetric(vertical: 0.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(29),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.green)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(29),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.purple)),
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
                        text: "SIGN IN",
                        press: () async {
                          try {
                            setState(
                              () {
                                isSpinner = true;
                              },
                            );
                            final user = await _auth.signInWithEmailAndPassword(
                                email: _email, password: _pass);

                            if (user != null) {
                              await storage.write(
                                  key: 'isLogged', value: 'true');

                              Navigator.pushReplacementNamed(
                                  context, '/bottomnav');
                            } else {
                              setState(() {
                                isSpinner = false;
                              });
                              displayDialog(context, 'Error',
                                  'No user found with corresponding email and password');
                            }
                          } catch (e) {
                            setState(() {
                              isSpinner = false;
                            });
                            switch (e.code) {
                              case "ERROR_INVALID_EMAIL":
                                displayDialog(context, 'Error',
                                    'Your email address appears to be malformed.');
                                break;
                              case "ERROR_WRONG_PASSWORD":
                                displayDialog(context, 'Error',
                                    'Your password is wrong.');

                                break;
                              case "ERROR_USER_NOT_FOUND":
                                displayDialog(context, 'Error',
                                    'User with this email doesn\'t exist.');

                                break;
                              case "ERROR_USER_DISABLED":
                                displayDialog(context, 'Error',
                                    'User with this email has been disabled.');

                                break;
                              case "ERROR_TOO_MANY_REQUESTS":
                                displayDialog(context, 'Error',
                                    'Too many requests. Try again later.');

                                break;
                              case "ERROR_OPERATION_NOT_ALLOWED":
                                displayDialog(context, 'Error',
                                    'Signing in with Email and Password is not enabled.');

                                break;
                              default:
                                displayDialog(context, 'Error',
                                    'An undefined Error happened.');
                            }
                            print(e);
                          }
                        },
                      ),
                      SizedBox(height: size.height * 0.01),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            forgpass = true;
                          });
                        },
                        child: Text(
                          "Forgot Password ?",
                          style: TextStyle(
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      AlreadyHaveAnAccountCheck(
                        press: () async {
                          Navigator.pushNamed(context, '/signup');
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
    );
  }

  Widget forgpassw() {
    Size size = MediaQuery.of(context).size;
    return Container(
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
                                borderSide:
                                    BorderSide(width: 2, color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(29),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.purple)),
                            hintText: "Enter your Registered id",
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
                      SizedBox(height: size.height * 0.05),
                      RoundedButton(
                        text: "Reset Password",
                        press: () async {
                          try {
                            setState(
                              () {
                                isSpinner = true;
                              },
                            );
                            final user = await _auth.sendPasswordResetEmail(
                                email: _email);
                            displaySuccessBox(context, 'Success',
                                'Check your email to reset password.');
                            setState(() {
                              isSpinner = false;
                              forgpass = false;
                            });
                          } catch (e) {
                            if (e.toString().contains('ERROR_USER_NOT_FOUND')) {
                              displayDialog(
                                  context, 'Error', 'Email not found');
                            } else {
                              displayDialog(
                                  context, 'Error', 'Some error occured.');
                            }
                            setState(() {
                              isSpinner = false;
                            });
                            print(e);
                          }
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
    );
  }
}
