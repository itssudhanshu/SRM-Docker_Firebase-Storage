import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:srm_notes/components/already_have_an_account_acheck.dart';
import 'package:srm_notes/components/rounded_button.dart';
import 'package:srm_notes/components/rounded_input_field.dart';
import 'package:srm_notes/components/rounded_password_field.dart';
import 'package:srm_notes/screens/HomePage.dart';
import 'package:srm_notes/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../constants.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  bool isSpinner= false;
  String _name;
  String _reg;
  String _email;
  String _pass;
  String _confirmPass;

  createUser() async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _pass);
      if (newUser != null) {
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=> HomePage()
        ));
      }
      else
      {
        displayDialog(context, 'Error', 'Some error occured.');
      }
    }
    catch(e){
      displayDialog(context, 'Error', 'Some error occured.');
      print(e);
    }
  }
  addUser() async {
    var response = await _fireStore.
    collection('users').
    document('$_email').
    setData({
      'name' : _name,
      'email' : _email,
      'regno' : _reg
    });
  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: isSpinner,
      child: Scaffold(
        body: Container(
          height: size.height,
          width: double.infinity,
          // Here i can use size.width but use double.infinity because both work as a same
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "assets/images/signup_top.png",
                  width: size.width * 0.35,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset(
                  "assets/images/main_bottom.png",
                  width: size.width * 0.25,
                ),
              ),
              // Positioned(
              //   top: 50,
              //   left: 100,
              //   child: SvgPicture.asset(
              //     "assets/icons/signup.svg",
              //     height: size.height * 0.35,

              //   ),
              // ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "SIGNUP",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                    ),
                    SizedBox(height: size.height * 0.03),
                    // SvgPicture.asset(
                    //   "assets/icons/signup.svg",
                    //   height: size.height * 0.35,
                    // ),
                    RoundedInputField(
                      hintText: "Full Name",
                      onChanged: (value) {
                        _name = value;
                      },
                    ),
                    RoundedInputField(
                      hintText: "ex. RA1711003011424",
                      onChanged: (value) {
                        _reg = value;
                      },
                    ),
                    RoundedEmailField(
                      hintText: "@srmist.edu.in",
                      onChanged: (value) {
                        _email = value;
                      },
                    ),
                    RoundedPasswordField(
                      hintText: "Password",
                      onChanged: (value) {
                        _pass = value;
                      },
                    ),
                    RoundedPasswordField(
                      hintText: "Confirm Password",
                      onChanged: (value) {
                        _confirmPass = value;
                      },
                    ),
                    RoundedButton(
                      text: "SIGNUP",
                      press: () async {
                        print(_email);
                        print(_pass);
                        print(_confirmPass);
                        if(_confirmPass == _pass && _email.contains('.com')
                            && _name != null
                            && _pass != null
                           && _reg != null
                        ){
                          setState(() {
                            isSpinner = true;
                          });
                          print('inside');
                          await createUser();
                          await addUser();
                          setState(() {
                            isSpinner = false;
                          });
                        }
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                    AlreadyHaveAnAccountCheck(
                      login: false,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

